--!strict
-- Guards system — Banana Guard AI for Candy Kingdom.
-- Lives in ServerScriptService.Server.Guards.Init
--
-- Design (per GMD §2A.3 + LOCATIONS_DOC §1.1.6):
--   * Patrol loop in Candy Kingdom (between town square, market, residential, barracks)
--   * Chase when player reputation is Wanted or Hunted
--   * At Hunted: attack on sight
--   * Interactions: Bribe (pay gold to drop rep), Fight (enter combat), Sneak (hide), Impersonate (post-beta)
--   * Caught player goes to Banana Guard Dungeon
--   * Guard spawning: 4 guards patrol Candy Kingdom, 2 at dungeon entrance

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"):WaitForChild("Init"))

local Guards = {}

-- Guard state per player (who they're chasing, if at all)
local chasing = {} :: { [number]: boolean }

-- Guard model placeholder (real model later)
local function makeGuard(position: Vector3): Model
	local m = Instance.new("Model")
	m.Name = "BananaGuard"
	m.Parent = Workspace

	-- Body (yellow capsule-ish)
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(2, 4, 1.5)
	body.Position = position
	body.Color = Color3.fromRGB(255, 220, 80)
	body.Anchored = true
	body.Parent = m

	-- Helmet (yellow hat)
	local helmet = Instance.new("Part")
	helmet.Name = "Helmet"
	helmet.Size = Vector3.new(2.2, 1, 1.7)
	helmet.Position = position + Vector3.new(0, 2.5, 0)
	helmet.Color = Color3.fromRGB(255, 200, 60)
	helmet.Anchored = true
	helmet.Parent = m

	-- Eye band (darker strip)
	local eyeBand = Instance.new("Part")
	eyeBand.Name = "EyeBand"
	eyeBand.Size = Vector3.new(2.3, 0.5, 1.8)
	eyeBand.Position = position + Vector3.new(0, 1.8, 0)
	eyeBand.Color = Color3.fromRGB(200, 160, 40)
	eyeBand.Anchored = true
	eyeBand.Parent = m

	m.PrimaryPart = body
	m:SetAttribute("IsGuard", true)
	m:SetAttribute("GuardState", "Patrolling")
	m:SetAttribute("HomePosition", position)
	return m
end

-- Spawn 4 guards patrolling Candy Kingdom + 2 at dungeon entrance
local function spawnGuards()
	local ck = Workspace:FindFirstChild("CandyKingdom")
	if not ck then
		return
	end

	local guardPositions = {
		-- Town square patrol
		Vector3.new(-20, 0, 50),
		Vector3.new(20, 0, 50),
		Vector3.new(0, 0, 80),
		-- Market street patrol
		Vector3.new(60, 0, 80),
		-- Barracks (2 stationed)
		Vector3.new(75, 0, 0),
		Vector3.new(85, 0, 0),
	}

	for i, pos in ipairs(guardPositions) do
		local guard = makeGuard(pos)
		guard.Name = "BananaGuard" .. i
		-- Patrol wander (placeholder — real pathfinding later)
		task.spawn(function()
			while guard.Parent do
				-- Simple wander: drift around home position
				local home = guard:GetAttribute("HomePosition")
				local driftX = math.random(-10, 10)
				local driftZ = math.random(-10, 10)
				local target = home + Vector3.new(driftX, 0, driftZ)
				local start = guard:GetPrimaryPartCFrame().Position
				local steps = 20
				for s = 1, steps do
					if not guard.Parent then
						break
					end
					local t = s / steps
					guard:SetPrimaryPartCFrame(CFrame.new(start:Lerp(target, t)))
					task.wait(0.1)
				end
				task.wait(math.random(2, 5))
			end
		end)
	end

	print("[Guards] spawned 6 Banana Guards")
end

-- Check if a player should be chased (reputation check)
local function shouldChase(player: Player): boolean
	local data = DataStore.Get(player.UserId)
	if not data then
		return false
	end
	local tier = data.reputation.CandyKingdom.tier
	return tier == "Wanted" or tier == "Hunted"
end

-- Chase loop — guards chase players with bad reputation
local function chaseLoop()
	while true do
		for _, player in ipairs(Players:GetPlayers()) do
			if shouldChase(player) then
				local char = player.Character
				if char and char.PrimaryPart then
					-- Find nearest guard
					local nearest = nil
					local nearestDist = math.huge
					for _, obj in ipairs(Workspace:GetChildren()) do
						if obj:IsA("Model") and obj:GetAttribute("IsGuard") then
							local guardPart = obj.PrimaryPart
							if guardPart then
								local dist = (guardPart.Position - char.PrimaryPart.Position).Magnitude
								if dist < nearestDist then
									nearestDist = dist
									nearest = obj
								end
							end
						end
					end

					if nearest and nearestDist < 30 and not chasing[player.UserId] then
						chasing[player.UserId] = true
						nearest:SetAttribute("GuardState", "Chasing")
						-- Move guard toward player (placeholder — real pathfinding later)
						task.spawn(function()
							while player.Character and player.Character.PrimaryPart and chasing[player.UserId] do
								local target = player.Character.PrimaryPart.Position
								local start = nearest:GetPrimaryPartCFrame().Position
								local steps = 10
								for s = 1, steps do
									if not player.Character or not player.Character.PrimaryPart or not chasing[player.UserId] then
										break
									end
									local t = s / steps
									nearest:SetPrimaryPartCFrame(CFrame.new(start:Lerp(target, t)))
									task.wait(0.05)
								end
								task.wait(0.2)
							end
							nearest:SetAttribute("GuardState", "Patrolling")
							chasing[player.UserId] = false
						end)
					end
				end
			else
				chasing[player.UserId] = false
			end
		end
		task.wait(0.5)
	end
end

-- Handle bribe (client fires ClientToServer "BribeGuard")
local function onBribe(player: Player, _payload: any)
	local data = DataStore.Get(player.UserId)
	if not data then
		return
	end
	local cost = 10
	if data.gold >= cost then
		data.gold -= cost
		DataStore.Set(player.UserId, data)
		-- Restore some reputation
		local reputation = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Reputation"):WaitForChild("Init"))
		reputation.Change(player, "BribeBananaGuard")
		print(("[Guards] %s bribed a guard (-%d gold)"):format(player.Name, cost))
	end
end

-- Handle guard catch (player caught by guard → dungeon)
local function onGuardCatch(player: Player, _payload: any)
	-- Teleport to dungeon entrance (placeholder — real dungeon later)
	local char = player.Character
	if char and char.PrimaryPart then
		char:SetPrimaryPartCFrame(CFrame.new(80, 5, 12)) -- dungeon entrance position
	end
	-- Reset reputation to -40 (Neutral after dungeon)
	local data = DataStore.Get(player.UserId)
	if data then
		data.reputation.CandyKingdom.value = -40
		data.reputation.CandyKingdom.tier = "Disliked"
		DataStore.Set(player.UserId, data)
	end
	chasing[player.UserId] = false
	print(("[Guards] %s caught and sent to dungeon"):format(player.Name))
end

function Guards.Init()
	-- Spawn guards after world is built (Spawns.Init runs before this in bootstrap order)
	spawnGuards()

	-- Hook ClientToServer for guard interactions
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(function(player: Player, action: string, payload: any)
			if action == "BribeGuard" then
				onBribe(player, payload)
			elseif action == "GuardCatch" then
				onGuardCatch(player, payload)
			end
		end)
	end

	-- Start chase loop
	task.spawn(chaseLoop)

	print("[Guards] initialized")
end

return Guards
