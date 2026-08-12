--!strict
-- RNG system — server-authoritative race/bloodline/talent rolling.
-- Lives in ServerScriptService.Server.RNG.Init
--
-- Design (per GMD §3):
--   * On PlayerDataReady, if data.firstSpawn is true (or race is empty), roll
--     race (weighted by tier) + bloodline + talent.
--   * Write results into PlayerData, mark firstSpawn = false, save.
--   * Fire RNGRolled BindableEvent so other systems (HUD, character model, etc.) react.
--   * Reroll tokens come post-beta (Season 1). In beta, the first roll is fixed.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"):WaitForChild("GameConstants"))
local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"):WaitForChild("Init"))

local RACES = Constants.RACES
local TIER_WEIGHTS = Constants.TIER_WEIGHTS
local BLOODLINES = Constants.BLOODLINES
local TALENTS = Constants.TALENTS

local RNG = {}

-- Build a weighted list of race IDs per tier for fast picking
local function buildTierRaceMap()
	local map: { [string]: { string } } = {}
	for id, def in pairs(RACES) do
		if not map[def.tier] then
			map[def.tier] = {}
		end
		table.insert(map[def.tier], id)
	end
	return map
end

local TIER_RACE_MAP = buildTierRaceMap()
local TIER_ORDER = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic" }

-- Pick a tier using weighted random, then pick a race uniformly within that tier.
local function rollRace(): string
	local roll = math.random()
	local cumulative = 0
	for _, tier in ipairs(TIER_ORDER) do
		cumulative += TIER_WEIGHTS[tier]
		if roll <= cumulative then
			local races = TIER_RACE_MAP[tier]
			if races and #races > 0 then
				return races[math.random(1, #races)]
			end
		end
	end
	-- Fallback (shouldn't happen, but safety)
	return "CandyPerson"
end

-- Pick a bloodline. Weights: common bloodlines more likely, rare ones rarer.
-- For beta simplicity, uniform random across all bloodlines except LichTouched (Mythic — very rare).
local function rollBloodline(): string
	local ids = {}
	for id, _ in pairs(BLOODLINES) do
		table.insert(ids, id)
	end
	-- LichTouched only rolls with 1% chance (it's a prestige cursed line)
	if math.random() < 0.01 then
		return "LichTouched"
	end
	-- Otherwise exclude LichTouched from the pool
	local pool = {}
	for _, id in ipairs(ids) do
		if id ~= "LichTouched" then
			table.insert(pool, id)
		end
	end
	return pool[math.random(1, #pool)]
end

-- Pick a talent uniformly from the 15 talents.
local function rollTalent(): string
	return TALENTS[math.random(1, #TALENTS)]
end

-- Roll all three and return them.
function RNG.RollAll(): { race: string, bloodline: string, talent: string }
	return {
		race = rollRace(),
		bloodline = rollBloodline(),
		talent = rollTalent(),
	}
end

-- Apply a roll to a player's data.
function RNG.ApplyRoll(data: any, roll: { race: string, bloodline: string, talent: string }): any
	data.race = roll.race
	data.bloodline = roll.bloodline
	data.talent = roll.talent
	data.firstSpawn = false
	return data
end

-- Listen for PlayerDataReady and roll if needed.
local function onPlayerDataReady(player: Player, data: any)
	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	local function fireRNGResult(roll: { race: string, bloodline: string, talent: string })
		if s2c and s2c:IsA("RemoteEvent") then
			s2c:FireClient(player, "RNGResult", roll)
		end
	end

	if data.firstSpawn or data.race == "" then
		local roll = RNG.RollAll()
		RNG.ApplyRoll(data, roll)
		DataStore.Set(player.UserId, data)
		DataStore.SaveAsync(player.UserId, data)
		fireRNGResult(roll)
		print(("[RNG] %s rolled: %s / %s / %s"):format(player.Name, data.race, data.bloodline, data.talent))
	else
		-- Existing player — fire their loaded roll so the client can show it once (optional)
		-- (For returning players we don't show the screen — handled client-side by checking firstSpawn)
		local rolledEvent = ReplicatedStorage:FindFirstChild("RNGRolled")
		if rolledEvent and rolledEvent:IsA("BindableEvent") then
			rolledEvent:Fire(player, data)
		end
	end
end

-- Handle ConfirmRNG from client (player acknowledged their roll)
local function onClientToServer(player: Player, action: string, _payload: any?)
	if action == "ConfirmRNG" then
		local data = DataStore.Get(player.UserId)
		if data and data.firstSpawn == false then
			-- Already rolled — just save (no-op essentially)
			DataStore.SaveAsync(player.UserId, data)
		end
	end
end

-- Handle RequestPlayerData from client
local function onRequestPlayerData(player: Player): any?
	local data = DataStore.Get(player.UserId)
	if data then
		-- Return a safe snapshot (no sensitive fields)
		return {
			race = data.race,
			bloodline = data.bloodline,
			talent = data.talent,
			level = data.level,
			gold = data.gold,
			firstSpawn = data.firstSpawn,
			isFounder = data.isFounder,
		}
	end
	return nil
end

function RNG.Init()
	-- Seed math.random
	math.randomseed(os.time() + os.clock())

	-- Hook PlayerDataReady
	local readyEvent = ReplicatedStorage:FindFirstChild("PlayerDataReady")
	if readyEvent and readyEvent:IsA("BindableEvent") then
		readyEvent.Event:Connect(function(player: Player, data: any)
			onPlayerDataReady(player, data)
		end)
	else
		warn("[RNG] PlayerDataReady BindableEvent not found — make sure RemotesSetup runs first")
	end

	-- Hook ClientToServer for ConfirmRNG
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(function(player: Player, action: string, payload: any)
			onClientToServer(player, action, payload)
		end)
	end

	-- Hook RequestPlayerData RemoteFunction
	local requestFn = ReplicatedStorage:FindFirstChild("RequestPlayerData")
	if requestFn and requestFn:IsA("RemoteFunction") then
		requestFn.OnServerInvoke = function(player: Player)
			return onRequestPlayerData(player)
		end
	end

	-- Create the RNGRolled BindableEvent if RemotesSetup didn't (defensive)
	if not ReplicatedStorage:FindFirstChild("RNGRolled") then
		local ev = Instance.new("BindableEvent")
		ev.Name = "RNGRolled"
		ev.Parent = ReplicatedStorage
	end

	print("[RNG] initialized")
end

return RNG
