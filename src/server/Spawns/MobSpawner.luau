--!strict
-- Mob system — spawn + simple AI for beta mobs.
-- Lives in ServerScriptService.Server.Spawns.MobSpawner
--
-- Mobs: Wild Berry Wolf (Grasslands), Candy Bandit (Grasslands),
-- Sugar Sprout (Grasslands), Mushroom (Mushfield).
-- AI: wander -> aggro on proximity -> attack -> return to wander.

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Combat = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Combat"))

local MobSpawner = {}

-- Mob definitions
local MOB_TYPES = {
	WildBerryWolf = {
		name = "Wild Berry Wolf",
		color = Color3.fromRGB(120, 80, 140),
		size = Vector3.new(4, 3, 6),
		hp = 60,
		damage = 12,
		speed = 14,
		aggroRange = 20,
		attackRange = 5,
		xp = 25,
	},
	CandyBandit = {
		name = "Candy Bandit",
		color = Color3.fromRGB(200, 120, 60),
		size = Vector3.new(3, 5, 3),
		hp = 40,
		damage = 8,
		speed = 10,
		aggroRange = 15,
		attackRange = 4,
		xp = 15,
	},
	SugarSprout = {
		name = "Sugar Sprout",
		color = Color3.fromRGB(255, 180, 200),
		size = Vector3.new(2, 2, 2),
		hp = 20,
		damage = 4,
		speed = 6,
		aggroRange = 10,
		attackRange = 3,
		xp = 8,
	},
	Mushroom = {
		name = "Mushroom",
		color = Color3.fromRGB(220, 100, 100),
		size = Vector3.new(2, 2, 2),
		hp = 25,
		damage = 5,
		speed = 4,
		aggroRange = 8,
		attackRange = 3,
		xp = 10,
	},
}

-- Spawn points per zone
local SPAWN_POINTS = {
	-- Grasslands
	{ type = "WildBerryWolf", position = Vector3.new(0, 2, -750), zone = "Grasslands" },
	{ type = "WildBerryWolf", position = Vector3.new(10, 2, -745), zone = "Grasslands" },
	{ type = "WildBerryWolf", position = Vector3.new(-10, 2, -755), zone = "Grasslands" },
	{ type = "CandyBandit", position = Vector3.new(120, 2, -550), zone = "Grasslands" },
	{ type = "CandyBandit", position = Vector3.new(125, 2, -545), zone = "Grasslands" },
	{ type = "SugarSprout", position = Vector3.new(0, 2, -600), zone = "Grasslands" },
	{ type = "SugarSprout", position = Vector3.new(15, 2, -610), zone = "Grasslands" },
	{ type = "SugarSprout", position = Vector3.new(-15, 2, -590), zone = "Grasslands" },
	-- Mushfield
	{ type = "Mushroom", position = Vector3.new(-30, 2, -650), zone = "Grasslands" },
	{ type = "Mushroom", position = Vector3.new(0, 2, -650), zone = "Grasslands" },
	{ type = "Mushroom", position = Vector3.new(30, 2, -650), zone = "Grasslands" },
}

-- Active mobs
local mobs = {} :: { [Model]: any }

-- Create a mob model (placeholder — real models swapped in later)
local function createMobModel(mobType: string, position: Vector3): Model
	local def = MOB_TYPES[mobType]
	local model = Instance.new("Model")
	model.Name = mobType
	model.Parent = Workspace

	local body = Instance.new("Part")
	body.Name = "HumanoidRootPart"
	body.Size = def.size
	body.Position = position
	body.Color = def.color
	body.Anchored = false
	body.CanCollide = true
	body.Parent = model

	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = def.hp
	humanoid.Health = def.hp
	humanoid.WalkSpeed = def.speed
	humanoid.Parent = model

	model.PrimaryPart = body

	-- Tags
	model:SetAttribute("MobType", mobType)
	model:SetAttribute("MobHP", def.hp)
	model:SetAttribute("MobMaxHP", def.hp)
	model:SetAttribute("MobDamage", def.damage)
	model:SetAttribute("MobXP", def.xp)
	model:SetAttribute("AggroRange", def.aggroRange)
	model:SetAttribute("AttackRange", def.attackRange)
	model:SetAttribute("HomePosition", position)

	return model
end

-- Simple AI loop for a mob
local function mobAILoop(model: Model)
	local def = MOB_TYPES[model:GetAttribute("MobType") :: string]
	local humanoid = model:WaitForChild("Humanoid") :: Humanoid
	local root = model:WaitForChild("HumanoidRootPart") :: Part
	local homePos = model:GetAttribute("HomePosition") :: Vector3

	local state = "wander"
	local target: Player? = nil
	local wanderTarget = homePos

	while model.Parent do
		-- Find nearest player within aggro range
		local nearestPlayer: Player? = nil
		local nearestDist = math.huge
		for _, player in ipairs(Players:GetPlayers()) do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
				if dist < nearestDist and dist <= def.aggroRange then
					nearestPlayer = player
					nearestDist = dist
				end
			end
		end

		if nearestPlayer and nearestDist <= def.aggroRange then
			state = "aggro"
			target = nearestPlayer
		elseif state == "aggro" and (not nearestPlayer or nearestDist > def.aggroRange * 1.5) then
			state = "return"
			target = nil
		end

		if state == "wander" then
			-- Random walk near home
			if (root.Position - wanderTarget).Magnitude < 2 then
				wanderTarget = homePos + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15))
			end
			humanoid:MoveTo(wanderTarget)

		elseif state == "aggro" and target and target.Character then
			local targetRoot = target.Character:FindFirstChild("HumanoidRootPart") :: Part?
			if targetRoot then
				local dist = (targetRoot.Position - root.Position).Magnitude
				if dist <= def.attackRange then
					-- Attack
					humanoid:MoveTo(root.Position) -- stop moving
					-- Damage the player
					Combat.DamageFromMob(target, def.damage)
					-- Face the target
					local lookAt = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
					root.CFrame = lookAt
					task.wait(1) -- attack cooldown
				else
					-- Chase
					humanoid:MoveTo(targetRoot.Position)
				end
			else
				state = "return"
				target = nil
			end

		elseif state == "return" then
			humanoid:MoveTo(homePos)
			if (root.Position - homePos).Magnitude < 3 then
				state = "wander"
			end
		end

		task.wait(0.5)
	end
end

-- Spawn all mobs
function MobSpawner.SpawnAll()
	for _, spawn in ipairs(SPAWN_POINTS) do
		local model = createMobModel(spawn.type, spawn.position)
		mobs[model] = spawn
		task.spawn(mobAILoop, model)
	end
	print(("[MobSpawner] spawned %d mobs"):format(#SPAWN_POINTS))
end

-- Clean up on server shutdown
function MobSpawner.Cleanup()
	for model, _ in pairs(mobs) do
		if model.Parent then
			model:Destroy()
		end
	end
	mobs = {}
end

return MobSpawner
