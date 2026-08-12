--!strict
-- Reputation system — Candy Kingdom reputation meter.
-- Lives in ServerScriptService.Server.Reputation.Init
--
-- Design (per GMD §2A.3 + LOCATIONS_DOC §1.1.6):
--   * -100 to +100 scale, tiered (Beloved/Liked/Neutral/Disliked/Wanted/Hunted)
--   * Eating candy people drops reputation
--   * Guards chase you at Wanted, attack on sight at Hunted
--   * Vendor prices scale with tier
--   * Broadcast to client via ServerToClient Reputation event

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"):WaitForChild("GameConstants"))
local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"):WaitForChild("Init"))

local REPUTATION_TIERS = Constants.REPUTATION_TIERS

local Reputation = {}

-- Reputation change events (positive = good, negative = bad)
-- Locked values from GMD §2A.3
local CHANGE_EVENTS = {
	EatCandyPerson = -15,
	BribeBananaGuard = -5,
	FightBananaGuard = -30,
	EscapeDungeon = -25,
	CompleteQuest = 10,
	HelpCitizen = 5,
	HealAlly = 3,
	EatCandyItem = -1, -- eating candy items (not people) — minor
}

-- Get the tier for a given reputation value
local function getTier(value: number): string
	for _, t in ipairs(REPUTATION_TIERS) do
		if value >= t.min and value <= t.max then
			return t.name
		end
	end
	return "Neutral"
end

-- Change reputation for a player. Returns the new tier.
function Reputation.Change(player: Player, event: string, amount: number?): string?
	local data = DataStore.Get(player.UserId)
	if not data then
		return nil
	end

	local delta = amount or CHANGE_EVENTS[event] or 0
	local current = data.reputation.CandyKingdom.value
	local newValue = math.clamp(current + delta, -100, 100)
	data.reputation.CandyKingdom.value = newValue

	local newTier = getTier(newValue)
	local oldTier = data.reputation.CandyKingdom.tier
	data.reputation.CandyKingdom.tier = newTier

	DataStore.Set(player.UserId, data)

	-- Broadcast to client
	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	if s2c and s2c:IsA("RemoteEvent") then
		s2c:FireClient(player, "Reputation", {
			tier = newTier,
			value = newValue,
			delta = delta,
			event = event,
		})
	end

	-- Fire event so Guards system can react to tier change
	if newTier ~= oldTier then
		local tierChangedEvent = ReplicatedStorage:FindFirstChild("ReputationTierChanged")
		if tierChangedEvent and tierChangedEvent:IsA("BindableEvent") then
			tierChangedEvent:Fire(player, oldTier, newTier)
		end
		print(("[Reputation] %s tier changed: %s -> %s (%d)"):format(player.Name, oldTier, newTier, newValue))
	end

	return newTier
end

-- Get a player's reputation tier
function Reputation.GetTier(player: Player): string
	local data = DataStore.Get(player.UserId)
	if data then
		return data.reputation.CandyKingdom.tier
	end
	return "Neutral"
end

-- Get a player's reputation value
function Reputation.GetValue(player: Player): number
	local data = DataStore.Get(player.UserId)
	if data then
		return data.reputation.CandyKingdom.value
	end
	return 0
end

-- Hook into RNGRolled so returning players get their loaded reputation broadcast
local function onRNGRolled(player: Player, data: any)
	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	if s2c and s2c:IsA("RemoteEvent") then
		s2c:FireClient(player, "Reputation", {
			tier = data.reputation.CandyKingdom.tier,
			value = data.reputation.CandyKingdom.value,
		})
	end
end

function Reputation.Init()
	-- Hook RNGRolled to broadcast loaded reputation
	local rolledEvent = ReplicatedStorage:FindFirstChild("RNGRolled")
	if rolledEvent and rolledEvent:IsA("BindableEvent") then
		rolledEvent.Event:Connect(onRNGRolled)
	end

	-- Create ReputationTierChanged BindableEvent if missing
	if not ReplicatedStorage:FindFirstChild("ReputationTierChanged") then
		local ev = Instance.new("BindableEvent")
		ev.Name = "ReputationTierChanged"
		ev.Parent = ReplicatedStorage
	end

	print("[Reputation] initialized")
end

return Reputation
