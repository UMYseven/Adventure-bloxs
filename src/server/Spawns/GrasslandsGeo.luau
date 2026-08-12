--!strict
-- Grasslands + Tree Fort placeholder geometry.
-- Lives in ServerScriptService.Server.Spawns.GrasslandsGeo

local Workspace = game:GetService("Workspace")

local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local makePart = WorldBuilder._makePart
local makeSpawn = WorldBuilder._makeSpawn
local makeShrine = WorldBuilder._makeShrine
local makeSaveTerminal = WorldBuilder._makeSaveTerminal

local GrasslandsGeo = {}

function GrasslandsGeo.Build()
	local gl = Instance.new("Folder")
	gl.Name = "Grasslands"
	gl.Parent = Workspace

	-- Ground
	makePart({
		name = "GL_Ground",
		size = Vector3.new(600, 1, 600),
		position = Vector3.new(0, -0.5, -500),
		color = Color3.fromRGB(120, 200, 100),
		parent = gl,
	})

	-- Tree Fort (player home)
	local tf = Instance.new("Model")
	tf.Name = "TreeFort"
	tf.Parent = gl

	makePart({
		name = "TF_Trunk",
		size = Vector3.new(20, 30, 20),
		position = Vector3.new(0, 15, -500),
		color = Color3.fromRGB(140, 90, 60),
		parent = tf,
	})
	makePart({
		name = "TF_Canopy",
		size = Vector3.new(35, 8, 35),
		position = Vector3.new(0, 34, -500),
		color = Color3.fromRGB(80, 180, 80),
		parent = tf,
	})
	makePart({
		name = "TF_Door",
		size = Vector3.new(4, 6, 0.5),
		position = Vector3.new(0, 3, -489.5),
		color = Color3.fromRGB(80, 50, 30),
		material = Enum.Material.Wood,
		parent = tf,
	})
	tf:SetAttribute("IsTreeFort", true)

	-- Grasslands Camp (central hub)
	makePart({
		name = "CampGround",
		size = Vector3.new(40, 1, 40),
		position = Vector3.new(0, 0.5, -600),
		color = Color3.fromRGB(150, 210, 130),
		parent = gl,
	})
	makeShrine("GL_Shrine", Vector3.new(0, 0.5, -600))
	makeSaveTerminal("GL_Save", Vector3.new(8, 0.5, -600))
	makeSpawn("GL_Spawn", Vector3.new(0, 0.5, -620), gl)

	-- Old Road connecting to Candy Kingdom gates
	makePart({
		name = "OldRoad",
		size = Vector3.new(8, 1, 200),
		position = Vector3.new(0, 0.5, -350),
		color = Color3.fromRGB(180, 180, 150),
		parent = gl,
	})

	-- Hilltop Shrine (north)
	makePart({
		name = "Hilltop",
		size = Vector3.new(30, 8, 30),
		position = Vector3.new(0, 4, -700),
		color = Color3.fromRGB(140, 190, 110),
		parent = gl,
	})

	-- Ruined Outpost (east)
	makePart({
		name = "RuinedOutpost",
		size = Vector3.new(40, 6, 40),
		position = Vector3.new(120, 3, -550),
		color = Color3.fromRGB(120, 100, 80),
		parent = gl,
	})

	-- River Crossing (south)
	makePart({
		name = "River",
		size = Vector3.new(200, 2, 30),
		position = Vector3.new(0, 0, -800),
		color = Color3.fromRGB(100, 180, 240),
		material = Enum.Material.Glass,
		parent = gl,
	})
	makePart({
		name = "RiverBank",
		size = Vector3.new(200, 1, 20),
		position = Vector3.new(0, 0.5, -780),
		color = Color3.fromRGB(180, 200, 150),
		parent = gl,
	})

	-- Wild Berry Wolf Den (north)
	makePart({
		name = "WolfDen",
		size = Vector3.new(30, 6, 30),
		position = Vector3.new(0, 3, -750),
		color = Color3.fromRGB(100, 80, 120),
		parent = gl,
	})

	-- Whispering Oak Grove (west)
	makePart({
		name = "OakGrove",
		size = Vector3.new(60, 1, 60),
		position = Vector3.new(-150, 0.5, -550),
		color = Color3.fromRGB(80, 120, 80),
		parent = gl,
	})
	for i = 1, 10 do
		makePart({
			name = "OakTree" .. i,
			size = Vector3.new(2, 12, 2),
			position = Vector3.new(-180 + (i * 4), 6, -540 - (i * 3)),
			color = Color3.fromRGB(100, 70, 50),
			parent = gl,
		})
		makePart({
			name = "OakLeaves" .. i,
			size = Vector3.new(8, 6, 8),
			position = Vector3.new(-180 + (i * 4), 14, -540 - (i * 3)),
			color = Color3.fromRGB(60, 100, 60),
			parent = gl,
		})
	end

	-- Mushfield (central, beginner-friendly)
	makePart({
		name = "Mushfield",
		size = Vector3.new(80, 1, 80),
		position = Vector3.new(0, 0.5, -650),
		color = Color3.fromRGB(180, 200, 140),
		parent = gl,
	})
	for i = 1, 6 do
		makePart({
			name = "Mushroom" .. i,
			size = Vector3.new(3, 4, 3),
			position = Vector3.new(-30 + (i * 12), 2, -650),
			color = Color3.fromRGB(220, 100, 100),
			parent = gl,
		})
		makePart({
			name = "MushroomCap" .. i,
			size = Vector3.new(5, 2, 5),
			position = Vector3.new(-30 + (i * 12), 4.5, -650),
			color = Color3.fromRGB(255, 180, 180),
			parent = gl,
		})
	end

	print("[WorldBuilder] Grasslands built")
end

return GrasslandsGeo
