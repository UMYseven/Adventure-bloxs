--!strict
-- Sugar Rush system — eat candy people → sugar meter → tiers → buffs → crash.
-- Lives in ServerScriptService.Server.SugarRush.Init
--
-- Design (per GMD §2A.2 + MVP_BETA_SCOPE):
--   * Sugar meter 0-10 (candy eaten count)
--   * 4 tiers: 1 candy = 15% buff 10s; 3 candy = 30% buff 20s + 5s crash;
--     5 candy = 50% buff 30s + 10s crash; 7+ candy = 75% buff 30s + 15s crash + coma
--   * Buffs: speed, strength, parkour ability
--   * Crash: -50% speed/strength debuff
--   * Coma (tier 4): player forced prone for 10s
--   * Hooks into Combat (strength buff) + Input (parkour) + HUD (sugar bar)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"):WaitForChild("GameConstants"))
local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"):WaitForChild("Init"))

local SUGAR_TIERS = Constants.SUGAR_RUSH_TIERS

local SugarRush = {}

-- Per-player sugar state (ephemeral)
local sugarState = {} :: { [number]: { count: number, tier: number, buffUntil: number, crashUntil: number, comatose: boolean } }

local function broadcastSugar(player: Player)
	local s = sugarState[player.UserId]
	if not s then
		return
	end
	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	if s2c and s2c:IsA("RemoteEvent") then
		s2c:FireClient(player, "Stats", { sugar = s.count, sugarTier = s.tier })
	end
end

-- Check if a buff/crash is currently active
local function _isBuffActive(userId: number): boolean
	local s = sugarState[userId]
	return s and os.clock() < s.buffUntil
end

local function _isCrashActive(userId: number): boolean
	local s = sugarState[userId]
	return s and os.clock() < s.crashUntil
end

-- Public API: eat a candy person (called by Interaction system)
function SugarRush.EatCandy(player: Player)
	local userId = player.UserId
	local s = sugarState[userId]
	if not s then
		return
	end

	-- Don't eat while in coma
	if s.comatose then
		return
	end

	s.count += 1

	-- Determine tier
	local tier = 0
	for _, t in ipairs(SUGAR_TIERS) do
		if s.count >= t.candy then
			tier = t.tier
		end
	end
	s.tier = tier

	-- Apply buff
	local buffData = SUGAR_TIERS[tier]
	if buffData then
		s.buffUntil = os.clock() + buffData.duration
		-- Broadcast to client so HUD shows the tier
		broadcastSugar(player)
		print(("[SugarRush] %s ate candy (count=%d, tier=%d)"):format(player.Name, s.count, tier))
	end

	-- Save count to data (persistent)
	local data = DataStore.Get(userId)
	if data then
		data.sugarMeter = s.count
		DataStore.Set(userId, data)
	end
end

-- Public API: check if player has sugar buff (for Combat/Input to read)
function SugarRush.GetBuff(userId: number): { speed: number, strength: number, parkour: number }?
	local s = sugarState[userId]
	if not s then
		return nil
	end
	if os.clock() < s.buffUntil then
		local buffData = SUGAR_TIERS[s.tier]
		return buffData and buffData.buff or nil
	end
	return nil
end

-- Public API: check if player has sugar crash debuff
function SugarRush.GetCrash(userId: number): { speed: number, strength: number }?
	local s = sugarState[userId]
	if not s then
		return nil
	end
	if os.clock() < s.crashUntil then
		local buffData = SUGAR_TIERS[s.tier]
		if buffData and buffData.crash > 0 then
			return { speed = -0.5, strength = -0.5 }
		end
	end
	return nil
end

-- Public API: is player in sugar coma
function SugarRush.IsComatose(userId: number): boolean
	local s = sugarState[userId]
	return s and s.comatose or false
end

-- Tick loop — check for buff end, apply crash, apply coma
local function tickLoop()
	while true do
		for userId, s in pairs(sugarState) do
			if not s then
				continue
			end
			local player = Players:GetPlayerByUserId(userId)
			if not player then
				sugarState[userId] = nil
				continue
			end

			local now = os.clock()

			-- Buff ended → start crash
			if s.buffUntil > 0 and now >= s.buffUntil then
				local buffData = SUGAR_TIERS[s.tier]
				if buffData and buffData.crash > 0 then
					s.crashUntil = now + buffData.crash
				end
				-- Coma on tier 4
				if s.tier >= 4 then
					s.comatose = true
					-- Force prone via Humanoid state (placeholder — real ragdoll later)
					task.delay(10, function()
						s.comatose = false
					end)
				end
				s.buffUntil = 0
				broadcastSugar(player)
			end

			-- Crash ended → reset
			if s.crashUntil > 0 and now >= s.crashUntil then
				s.crashUntil = 0
				s.count = 0
				s.tier = 0
				broadcastSugar(player)
				-- Clear saved sugar meter
				local data = DataStore.Get(userId)
				if data then
					data.sugarMeter = 0
					DataStore.Set(userId, data)
				end
			end
		end
		task.wait(0.5)
	end
end

-- Handle "EatCandyPerson" action from client (interaction system fires this)
local function onClientToServer(player: Player, action: string, _payload: any)
	if action == "EatCandyPerson" then
		SugarRush.EatCandy(player)
		-- Also drop reputation
		local reputation = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Reputation"):WaitForChild("Init"))
		reputation.Change(player, "EatCandyPerson")
	end
end

-- Init sugar state on PlayerDataReady
local function onPlayerDataReady(player: Player, _data: any)
	sugarState[player.UserId] = {
		count = 0,
		tier = 0,
		buffUntil = 0,
		crashUntil = 0,
		comatose = false,
	}
end

function SugarRush.Init()
	-- Hook PlayerDataReady
	local readyEvent = ReplicatedStorage:FindFirstChild("PlayerDataReady")
	if readyEvent and readyEvent:IsA("BindableEvent") then
		readyEvent.Event:Connect(onPlayerDataReady)
	end

	-- Hook ClientToServer for EatCandyPerson
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(onClientToServer)
	end

	-- Hook player leaving
	Players.PlayerRemoving:Connect(function(player: Player)
		sugarState[player.UserId] = nil
	end)

	-- Start tick loop
	task.spawn(tickLoop)

	print("[SugarRush] initialized")
end

return SugarRush
