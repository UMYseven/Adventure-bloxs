--!strict
-- World builder — constructs placeholder Candy Kingdom + Grasslands geometry from parts.
-- Lives in ServerScriptService.Server.Spawns.WorldBuilder
--
-- All parts are placeholders. Real models swapped in later via ASSETS_NEEDED.md.
-- Builds once on server start, parented to Workspace.

local Workspace = game:GetService("Workspace")

local WorldBuilder = {}

-- Helper: make a part with sensible defaults
local function makePart(props: {
	name: string,
	size: Vector3,
	position: Vector3,
	color: Color3,
	anchored: boolean?,
	parent: Instance?,
	transparency: number?,
	material: Enum.Material?,
}): Part
	local p = Instance.new("Part")
	p.Name = props.name
	p.Size = props.size
	p.Position = props.position
	p.Color = props.color
	p.Anchored = if props.anchored == nil then true else props.anchored
	p.Material = props.material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if props.transparency then
		p.Transparency = props.transparency
	end
	p.Parent = props.parent or Workspace
	return p
end

-- Helper: make a spawn point
local function makeSpawn(name: string, position: Vector3, parent: Instance): SpawnLocation
	local s = Instance.new("SpawnLocation")
	s.Name = name
	s.Size = Vector3.new(6, 1, 6)
	s.Position = position
	s.Color = Color3.fromRGB(120, 200, 120)
	s.Anchored = true
	s.Material = Enum.Material.Neon
	s.Neutral = true
	s.AllowTeamChangeOnTouch = false
	s.Duration = 0
	s.Parent = parent or Workspace
	return s
end

-- Helper: make a fast-travel shrine (Cosmic Owl statue placeholder)
local function makeShrine(name: string, position: Vector3): Model
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = Workspace

	makePart({
		name = "Base",
		size = Vector3.new(4, 0.5, 4),
		position = position,
		color = Color3.fromRGB(80, 80, 140),
		parent = m,
	})
	makePart({
		name = "Statue",
		size = Vector3.new(2, 4, 2),
		position = position + Vector3.new(0, 2.5, 0),
		color = Color3.fromRGB(180, 180, 220),
		material = Enum.Material.Neon,
		parent = m,
	})

	m:SetAttribute("IsShrine", true)
	m:SetAttribute("ShrineName", name)
	return m
end

-- Helper: make a BMO save terminal
local function makeSaveTerminal(name: string, position: Vector3): Model
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = Workspace

	makePart({
		name = "Base",
		size = Vector3.new(2, 0.5, 2),
		position = position,
		color = Color3.fromRGB(60, 180, 200),
		parent = m,
	})
	makePart({
		name = "Screen",
		size = Vector3.new(1.5, 2, 0.2),
		position = position + Vector3.new(0, 1.5, 0),
		color = Color3.fromRGB(100, 220, 240),
		material = Enum.Material.Neon,
		parent = m,
	})

	m:SetAttribute("IsSaveTerminal", true)
	m:SetAttribute("TerminalName", name)
	return m
end

-- Helper: make a gate (locked until starter arc done)
local function makeGate(name: string, position: Vector3, locked: boolean): Model
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = Workspace

	makePart({
		name = "LeftPillar",
		size = Vector3.new(2, 12, 2),
		position = position + Vector3.new(-3, 6, 0),
		color = Color3.fromRGB(220, 180, 100),
		parent = m,
	})
	makePart({
		name = "RightPillar",
		size = Vector3.new(2, 12, 2),
		position = position + Vector3.new(3, 6, 0),
		color = Color3.fromRGB(220, 180, 100),
		parent = m,
	})
	makePart({
		name = "Top",
		size = Vector3.new(8, 2, 2),
		position = position + Vector3.new(0, 13, 0),
		color = Color3.fromRGB(240, 200, 120),
		parent = m,
	})

	m:SetAttribute("IsGate", true)
	m:SetAttribute("GateName", name)
	m:SetAttribute("Locked", locked)
	return m
end

WorldBuilder._makePart = makePart
WorldBuilder._makeSpawn = makeSpawn
WorldBuilder._makeShrine = makeShrine
WorldBuilder._makeSaveTerminal = makeSaveTerminal
WorldBuilder._makeGate = makeGate

return WorldBuilder
