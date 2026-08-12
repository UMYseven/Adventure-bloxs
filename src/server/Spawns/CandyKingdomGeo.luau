--!strict
-- Candy Kingdom placeholder geometry.
-- Lives in ServerScriptService.Server.Spawns.CandyKingdomGeo

local Workspace = game:GetService("Workspace")

local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local makePart = WorldBuilder._makePart
local makeSpawn = WorldBuilder._makeSpawn
local makeShrine = WorldBuilder._makeShrine
local makeSaveTerminal = WorldBuilder._makeSaveTerminal
local makeGate = WorldBuilder._makeGate

local CandyKingdomGeo = {}

function CandyKingdomGeo.Build()
	local ck = Instance.new("Folder")
	ck.Name = "CandyKingdom"
	ck.Parent = Workspace

	-- Ground
	makePart({
		name = "CK_Ground",
		size = Vector3.new(400, 1, 400),
		position = Vector3.new(0, -0.5, 0),
		color = Color3.fromRGB(255, 200, 220),
		parent = ck,
	})

	-- Candy Castle (central)
	local castle = Instance.new("Model")
	castle.Name = "CandyCastle"
	castle.Parent = ck

	makePart({
		name = "CastleBase",
		size = Vector3.new(40, 4, 40),
		position = Vector3.new(0, 2, 0),
		color = Color3.fromRGB(255, 240, 230),
		parent = castle,
	})
	for _, offset in ipairs({ Vector3.new(-15, -15), Vector3.new(15, -15), Vector3.new(-15, 15), Vector3.new(15, 15) }) do
		makePart({
			name = "CastleTower",
			size = Vector3.new(8, 30, 8),
			position = Vector3.new(offset.X, 15, offset.Y),
			color = Color3.fromRGB(255, 180, 200),
			parent = castle,
		})
	end
	makePart({
		name = "CastleThroneRoom",
		size = Vector3.new(20, 8, 20),
		position = Vector3.new(0, 8, 0),
		color = Color3.fromRGB(255, 220, 240),
		parent = castle,
	})

	-- Town Square (south of castle)
	makePart({
		name = "TownSquare",
		size = Vector3.new(60, 1, 60),
		position = Vector3.new(0, 0.5, 50),
		color = Color3.fromRGB(255, 220, 240),
		parent = ck,
	})
	makeShrine("CK_Shrine", Vector3.new(0, 0.5, 50))
	makeSaveTerminal("CK_Save", Vector3.new(10, 0.5, 50))

	-- Residential district (west)
	makePart({
		name = "ResidentialGround",
		size = Vector3.new(80, 1, 80),
		position = Vector3.new(-80, 0.5, 0),
		color = Color3.fromRGB(255, 210, 230),
		parent = ck,
	})
	for i = 1, 6 do
		makePart({
			name = "CandyHouse" .. i,
			size = Vector3.new(10, 8, 10),
			position = Vector3.new(-120 + (i * 12), 4, -20),
			color = Color3.fromRGB(255, 150 + i * 10, 200),
			parent = ck,
		})
		makePart({
			name = "CandyHouseRoof" .. i,
			size = Vector3.new(12, 3, 12),
			position = Vector3.new(-120 + (i * 12), 9.5, -20),
			color = Color3.fromRGB(255, 100 + i * 10, 180),
			parent = ck,
		})
	end

	-- Market Street (south-east)
	makePart({
		name = "MarketGround",
		size = Vector3.new(60, 1, 20),
		position = Vector3.new(60, 0.5, 80),
		color = Color3.fromRGB(255, 230, 210),
		parent = ck,
	})
	for i = 1, 4 do
		makePart({
			name = "MarketStall" .. i,
			size = Vector3.new(8, 4, 6),
			position = Vector3.new(40 + (i * 12), 2, 80),
			color = Color3.fromRGB(255, 200, 150),
			parent = ck,
		})
	end

	-- Banana Guard Barracks (east)
	makePart({
		name = "Barracks",
		size = Vector3.new(30, 10, 20),
		position = Vector3.new(80, 5, 0),
		color = Color3.fromRGB(255, 220, 100),
		parent = ck,
	})

	-- Dungeon entrance (under barracks)
	local dungeonEntrance = Instance.new("Model")
	dungeonEntrance.Name = "BananaGuardDungeonEntrance"
	dungeonEntrance.Parent = ck
	makePart({
		name = "Trapdoor",
		size = Vector3.new(6, 0.5, 6),
		position = Vector3.new(80, 0.5, 12),
		color = Color3.fromRGB(80, 60, 30),
		material = Enum.Material.Wood,
		parent = dungeonEntrance,
	})
	dungeonEntrance:SetAttribute("IsDungeonEntrance", true)
	dungeonEntrance:SetAttribute("DungeonName", "BananaGuardDungeon")

	-- Royal Tart Vault entrance (under castle)
	local vaultEntrance = Instance.new("Model")
	vaultEntrance.Name = "RoyalTartVaultEntrance"
	vaultEntrance.Parent = ck
	makePart({
		name = "VaultDoor",
		size = Vector3.new(4, 0.5, 4),
		position = Vector3.new(0, 0.5, 18),
		color = Color3.fromRGB(120, 80, 40),
		material = Enum.Material.Wood,
		parent = vaultEntrance,
	})
	vaultEntrance:SetAttribute("IsDungeonEntrance", true)
	vaultEntrance:SetAttribute("DungeonName", "RoyalTartVault")

	-- Candy Kingdom Gates (north, locked until starter arc done)
	makeGate("CandyKingdomGate", Vector3.new(0, 0, -180), true)

	-- Spawn point (town square)
	makeSpawn("CK_Spawn", Vector3.new(0, 0.5, 50), ck)

	-- Candy cane trees for flavor
	for i = 1, 8 do
		makePart({
			name = "CandyCaneTree" .. i,
			size = Vector3.new(1, 6, 1),
			position = Vector3.new(-180 + (i * 8), 3, 60),
			color = Color3.fromRGB(255, 255, 255),
			parent = ck,
		})
		makePart({
			name = "CandyCaneLeaves" .. i,
			size = Vector3.new(4, 3, 4),
			position = Vector3.new(-180 + (i * 8), 7.5, 60),
			color = Color3.fromRGB(255, 80, 120),
			parent = ck,
		})
	end

	print("[WorldBuilder] Candy Kingdom built")
end

return CandyKingdomGeo
