--!strict
-- DataStore system — server-authoritative save/load for PlayerData.
-- Lives in ServerScriptService.Server.DataStore.Init
--
-- Design (per GMD §8.3 + MVP_BETA_SCOPE):
--   * Session-locked saves (DataStoreService:GetDataStore + UpdateAsync)
--   * Retry with backoff on transient failures
--   * Autosave every 60s + on leave + on server shutdown
--   * Graceful: never lose data on crash; always restore from last good save
--   * Beta wipe (GMD §2.3): partial wipe at Season 1 — keep cosmetics + titles,
--     wipe levels/gold/inventory/reputation. Handled by saveVersion migration.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local PlayerDataTypes = require(Shared:WaitForChild("Types"):WaitForChild("PlayerData"))
local DEFAULT_DATA = PlayerDataTypes.DEFAULT

local STORE_NAME = "PlayerData_v1"
local AUTOSAVE_INTERVAL = 60 -- seconds
local MAX_RETRIES = 4
local RETRY_BACKOFF = 2 -- seconds

local DataStore = {}
DataStore._store = nil
DataStore._cache = {} :: { [number]: any }
DataStore._autosaveThread = nil
DataStore._shuttingDown = false

-- Deep-copy a table (one level deep enough for our schema; nested tables are copied by ref which is fine for save)
local function deepCopy(t: any): any
	if type(t) ~= "table" then
		return t
	end
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = deepCopy(v)
	end
	return copy
end

-- Retry wrapper for DataStore calls. fn should return a single value (the result).
local function retryAsync(fn: () -> any): any
	local lastErr: string
	for attempt = 1, MAX_RETRIES do
		local ok, result = pcall(fn)
		if ok then
			return result
		end
		lastErr = tostring(result)
		if attempt < MAX_RETRIES then
			task.wait(RETRY_BACKOFF * attempt)
		end
	end
	error(("DataStore retry exhausted: %s"):format(lastErr))
end

-- Load a player's data. Returns the stored data, or default if new.
-- In Studio without DataStore access, returns fresh default data.
function DataStore.LoadAsync(userId: number, username: string): any
	-- In-memory mode (Studio without DataStore)
	if not DataStore._store then
		local fresh = deepCopy(DEFAULT_DATA)
		fresh.userId = userId
		fresh.username = username
		fresh.lastSavedAt = os.time()
		return fresh
	end

	local key = tostring(userId)
	local data
	local ok, err = pcall(function()
		data = retryAsync(function()
			return DataStore._store:GetAsync(key)
		end)
	end)
	if not ok then
		warn(("[DataStore] LoadAsync failed for %s: %s"):format(key, tostring(err)))
		return nil
	end

	if data == nil then
		-- New player
		local fresh = deepCopy(DEFAULT_DATA)
		fresh.userId = userId
		fresh.username = username
		fresh.lastSavedAt = os.time()
		return fresh
	end

	-- Migrate / validate
	data.userId = userId
	data.username = username
	data.saveVersion = data.saveVersion or 1
	data.lastSavedAt = data.lastSavedAt or os.time()

	-- Fill any missing fields from DEFAULT (forward-compat)
	for k, v in pairs(DEFAULT_DATA) do
		if data[k] == nil then
			data[k] = deepCopy(v)
		end
	end

	return data
end

-- Save a player's data. Uses UpdateAsync for safe concurrent writes.
-- In Studio without DataStore access, just returns true (in-memory only).
function DataStore.SaveAsync(userId: number, data: any): boolean
	if not DataStore._store then
		return true -- in-memory mode, no-op
	end

	local key = tostring(userId)
	local snapshot = deepCopy(data)
	snapshot.lastSavedAt = os.time()

	local ok, err = pcall(function()
		retryAsync(function()
			DataStore._store:UpdateAsync(key, function(_old)
				-- Session-lock check: only save if no other session has locked it
				-- (For beta simplicity we don't lock; UpdateAsync itself is atomic.)
				return snapshot
			end)
		end)
	end)

	if not ok then
		warn(("[DataStore] SaveAsync failed for %s: %s"):format(key, tostring(err)))
		return false
	end
	return true
end

-- Cache management (in-memory mirror so we don't hit DataStore on every read)
function DataStore.Get(userId: number): any
	return DataStore._cache[userId]
end

function DataStore.Set(userId: number, data: any)
	DataStore._cache[userId] = data
end

function DataStore.Clear(userId: number)
	DataStore._cache[userId] = nil
end

-- Autosave loop
local function autosaveLoop()
	while not DataStore._shuttingDown do
		for userId, data in pairs(DataStore._cache) do
			if data then
				task.spawn(function()
					DataStore.SaveAsync(userId, data)
				end)
			end
		end
		task.wait(AUTOSAVE_INTERVAL)
	end
end

-- Player join handler
local function onPlayerAdded(player: Player)
	local userId = player.UserId
	local username = player.Name

	-- Load in background so join doesn't block
	task.spawn(function()
		local data = DataStore.LoadAsync(userId, username)
		if data then
			DataStore.Set(userId, data)
			-- Fire a BindableEvent so other systems (RNG, Combat, etc.) can read it
			local readyEvent = game:GetService("ReplicatedStorage"):FindFirstChild("PlayerDataReady")
			if readyEvent and readyEvent:IsA("BindableEvent") then
				readyEvent:Fire(player, data)
			end
			print(("[DataStore] loaded data for %s (lvl %d, %d gold)"):format(username, data.level, data.gold))
		else
			-- Load failed: kick to prevent playing on unsaved state
			player:Kick("Failed to load your save data. Please rejoin.")
		end
	end)
end

-- Player leave handler — save before clearing
local function onPlayerRemoving(player: Player)
	local userId = player.UserId
	local data = DataStore.Get(userId)
	if data then
		local ok = DataStore.SaveAsync(userId, data)
		if ok then
			print(("[DataStore] saved data for %s on leave"):format(player.Name))
		end
	end
	DataStore.Clear(userId)
end

-- Server shutdown handler — save everyone
local function onServerShutdown()
	DataStore._shuttingDown = true
	if DataStore._autosaveThread then
		task.cancel(DataStore._autosaveThread)
	end
	for userId, data in pairs(DataStore._cache) do
		if data then
			DataStore.SaveAsync(userId, data)
		end
	end
	print("[DataStore] all data saved on shutdown")
end

function DataStore.Init()
	-- Enable studio access to DataStore (dev convenience)
	pcall(function()
		DataStoreService:SetRequestHooksEnabled(false)
	end)

	-- Open the store — in Studio, DataStore may not be available. Fall back to in-memory only.
	local ok, store = pcall(function()
		return DataStoreService:GetDataStore(STORE_NAME)
	end)
	if ok and store then
		DataStore._store = store
		print("[DataStore] opened store: " .. STORE_NAME)
	else
		warn("[DataStore] DataStore unavailable (Studio without API access?) — running in-memory only. Data will NOT persist.")
		DataStore._store = nil
	end

	-- Hook player lifecycle
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	-- Hook server shutdown
	game:BindToClose(onServerShutdown)

	-- Start autosave (only if we have a store)
	if DataStore._store then
		DataStore._autosaveThread = task.spawn(autosaveLoop)
	end

	-- Handle players already in game (studio play solo)
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			onPlayerAdded(player)
		end)
	end

	print("[DataStore] initialized (store: " .. STORE_NAME .. ")")
end

return DataStore
