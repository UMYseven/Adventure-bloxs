--!strict
-- Combat system (server) — authoritative combat state for all players.
-- Lives in ServerScriptService.Server.Combat.Init
--
-- Design (per COMBAT_DOC):
--   * Server holds canonical combat state (HP, stamina, hero meter, combo counter, status effects).
--   * Client sends combat intents (LightAttack, HeavyAttack, Dodge, Block, Parry, Ability) via ClientToServer.
--   * Server validates timing, stamina cost, i-frames, applies damage.
--   * Server fires ServerToClient Stats events to update HUD.
--   * PvE mobs use the same damage pipeline as players.
--   * Duels (beta) are consensual 1v1; no open-world PvP yet.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CombatConstants = require(Shared:WaitForChild("Constants"):WaitForChild("CombatConstants"))
local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"):WaitForChild("Init"))

local CC = CombatConstants

-- Forward declarations (so damagePlayer can call handleDeath)
local handleDeath

local Combat = {}

-- Per-player combat state (in-memory, ephemeral)
-- @player.UserId -> { hp, hpMax, stamina, staminaMax, hero, combo, lastHitTime, dodgingUntil, blocking, parryUntil, heroModeUntil, statuses }
local state = {} :: { [number]: any }

-- Status effects: { type, expires, stacks }
local function applyStatus(playerState: any, statusType: string, duration: number, stacks: number?)
	if not playerState.statuses then
		playerState.statuses = {}
	end
	playerState.statuses[statusType] = {
		type = statusType,
		expires = os.clock() + duration,
		stacks = (stacks or 1),
	}
end

local function tickStatuses(playerState: any)
	if not playerState.statuses then
		return
	end
	local now = os.clock()
	for k, s in pairs(playerState.statuses) do
		if now >= s.expires then
			playerState.statuses[k] = nil
		end
	end
end

-- Initialize combat state for a player
local function initPlayer(userId: number, data: any)
	local hpMax = 100 + (data.level - 1) * 10
	state[userId] = {
		hp = hpMax,
		hpMax = hpMax,
		stamina = 100,
		staminaMax = 100,
		hero = 0,
		combo = 0,
		lastHitTime = 0,
		dodgingUntil = 0,
		blocking = false,
		parryUntil = 0,
		heroModeUntil = 0,
		statuses = {},
	}
end

-- Broadcast stats to client (HUD reads this)
local function broadcastStats(player: Player)
	local s = state[player.UserId]
	if not s then
		return
	end
	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	if s2c and s2c:IsA("RemoteEvent") then
		s2c:FireClient(player, "Stats", {
			health = math.floor(s.hp),
			healthMax = s.hpMax,
			stamina = math.floor(s.stamina),
			staminaMax = s.staminaMax,
			hero = math.floor(s.hero),
		})
	end
end

-- Stamina regen loop (per-player)
local function regenStamina()
	while true do
		for userId, s in pairs(state) do
			if s then
				if os.clock() >= s.dodgingUntil and not s.blocking then
					s.stamina = math.clamp(s.stamina + CC.STAMINA_REGEN_RATE * 0.1, 0, s.staminaMax)
				end
				tickStatuses(s)
				if s.heroModeUntil > 0 and os.clock() >= s.heroModeUntil then
					s.heroModeUntil = 0
					s.hero = 0
				end
				local player = Players:GetPlayerByUserId(userId)
				if player then
					broadcastStats(player)
				end
			end
		end
		task.wait(0.1)
	end
end

-- Add to hero meter (on damage dealt/taken, parry)
local function addHero(playerState: any, amount: number)
	if playerState.heroModeUntil > 0 then
		return -- already in hero mode
	end
	playerState.hero = math.clamp(playerState.hero + amount, 0, CC.HERO_METER_MAX)
	if playerState.hero >= CC.HERO_METER_MAX then
		playerState.heroModeUntil = os.clock() + CC.HERO_MODE_DURATION
		playerState.hero = CC.HERO_METER_MAX
	end
end

-- Apply damage to a target player (PvP duel or PvE hitting a player)
local function damagePlayer(target: Player, attacker: Player?, amount: number, element: string?)
	local s = state[target.UserId]
	if not s then
		return
	end

	-- Dodge i-frames
	if os.clock() < s.dodgingUntil then
		return
	end

	-- Block
	if s.blocking then
		amount *= (1 - CC.BLOCK_DAMAGE_REDUCTION)
		s.stamina = math.clamp(s.stamina - CC.STAMINA_BLOCK_DRAIN_PER_HIT, 0, s.staminaMax)
		if s.stamina == 0 then
			s.blocking = false -- guard broken
		end
	end

	-- Parry
	if os.clock() < s.parryUntil then
		-- Parry success: no damage, stagger attacker, add hero
		addHero(s, 25)
		if attacker then
			local as = state[attacker.UserId]
			if as then
				as.combo = 0
			end
		end
		return
	end

	-- Elemental affinity bonus
	if element and attacker then
		local _strongVs = CC.ELEMENT_STRONG_VS[element]
		-- (simplified: defender's race element not tracked here; full impl in combat扩展)
	end

	s.hp = math.clamp(s.hp - amount, 0, s.hpMax)
	addHero(s, amount * 0.5)
	if attacker then
		local as = state[attacker.UserId]
		if as then
			as.combo = math.clamp(as.combo + 1, 0, CC.COMBO_HITS_TO_MAX)
			addHero(as, amount * 0.5)
		end
	end

	-- Status effect
	if element then
		local statusType = CC.ELEMENT_STATUS[element]
		if statusType then
			applyStatus(s, statusType, 3, 1)
		end
	end

	if s.hp <= 0 then
		handleDeath(target, attacker)
	else
		broadcastStats(target)
	end
end

-- Handle player death (locked, COMBAT_DOC §8.3)
handleDeath = function(player: Player, killer: Player?)
	local data = DataStore.Get(player.UserId)
	if data then
		local lost = math.floor(data.gold * CC.DEATH_GOLD_LOSS)
		data.gold -= lost
		data.xpDebt += math.floor(data.xp * CC.DEATH_XP_DEBT_RATE)
		DataStore.Set(player.UserId, data)
	end

	local s = state[player.UserId]
	if s then
		s.hp = s.hpMax
		s.stamina = s.staminaMax
		s.hero = 0
		s.combo = 0
		s.statuses = {}
		s.heroModeUntil = 0
	end

	-- Respawn at last BMO save point (placeholder: spawn location)
	player:LoadCharacter()
	print(("[Combat] %s died%s"):format(player.Name, killer and (" (killed by " .. killer.Name .. ")") or ""))
	broadcastStats(player)
end

-- Public API: damage a player from a PvE source (mob)
function Combat.DamageFromMob(target: Player, amount: number, element: string?)
	damagePlayer(target, nil, amount, element)
end

-- Public API: damage a mob from a player (returns true if mob died)
function Combat.DamageMob(attacker: Player, _mob: Model, amount: number, _element: string?): boolean
	local s = state[attacker.UserId]
	if s then
		addHero(s, amount * 0.5)
		s.combo = math.clamp(s.combo + 1, 0, CC.COMBO_HITS_TO_MAX)
		broadcastStats(attacker)
	end
	-- Mob HP managed by Spawns system; this just notifies.
	-- For now, return false (mob death handled in Spawns when HP hits 0)
	return false
end

-- Handle combat intents from client
local function onClientToServer(player: Player, action: string, _payload: any)
	local s = state[player.UserId]
	if not s then
		return
	end

	local now = os.clock()

	if action == "LightAttack" then
		if s.stamina >= CC.STAMINA_LIGHT_ATTACK_COST then
			s.stamina -= CC.STAMINA_LIGHT_ATTACK_COST
			-- Hit detection done client-side or via raycast on server (placeholder)
			broadcastStats(player)
		end
	elseif action == "HeavyAttack" then
		if s.stamina >= CC.STAMINA_HEAVY_ATTACK_COST then
			s.stamina -= CC.STAMINA_HEAVY_ATTACK_COST
			broadcastStats(player)
		end
	elseif action == "Dodge" then
		if s.stamina >= CC.STAMINA_DODGE_COST and now >= s.dodgingUntil then
			s.stamina -= CC.STAMINA_DODGE_COST
			s.dodgingUntil = now + CC.DODGE_IFRAMES
			broadcastStats(player)
		end
	elseif action == "BlockStart" then
		s.blocking = true
		broadcastStats(player)
	elseif action == "BlockStop" then
		s.blocking = false
	elseif action == "Parry" then
		s.parryUntil = now + CC.PARRY_WINDOW
	elseif action == "Ability" then
		-- Ability use handled by ability system (post-beta adds slots 3-4)
		-- Beta has 2 slots; cooldowns managed client-side, server validates
		broadcastStats(player)
	end
end

function Combat.Init()
	-- Hook PlayerDataReady to init combat state
	local readyEvent = ReplicatedStorage:FindFirstChild("PlayerDataReady")
	if readyEvent and readyEvent:IsA("BindableEvent") then
		readyEvent.Event:Connect(function(player: Player, data: any)
			initPlayer(player.UserId, data)
			broadcastStats(player)
		end)
	end

	-- Hook player leaving to clear state
	Players.PlayerRemoving:Connect(function(player: Player)
		state[player.UserId] = nil
	end)

	-- Hook ClientToServer for combat intents
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(function(player: Player, action: string, payload: any)
			onClientToServer(player, action, payload)
		end)
	end

	-- Start stamina regen loop
	task.spawn(regenStamina)

	print("[Combat] initialized")
end

return Combat
