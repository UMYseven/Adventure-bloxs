--!strict
-- Map / fast-travel screen — shows ALL planned locations.
-- Beta zones are interactable; post-beta zones are "coming soon" placeholders.
-- Lives in StarterPlayerScripts.Client.UI.MapScreen
--
-- Figma style: framed panel with gold title, legend row, dark map area with a
-- stylized landmass and diamond pin markers. Supports variants A/B/C.
-- Press M to open. Click a beta shrine to fast-travel.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local MapScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local shrineButtons = {} :: { [string]: TextButton }

-- All planned locations. status: "active" (beta), "coming" (post-beta, locked), "future" (season 5+, locked)
-- x/y are normalized 0-1 positions on the map.
local LOCATIONS = {
	-- ===== BETA (active) =====
	{ id = "CK_Shrine", name = "Candy Kingdom", x = 0.50, y = 0.30, status = "active", season = "Beta" },
	{ id = "GL_Shrine", name = "Grasslands Camp", x = 0.50, y = 0.55, status = "active", season = "Beta" },
	{ id = "TreeFort", name = "Tree Fort", x = 0.48, y = 0.62, status = "active", season = "Beta" },
	{ id = "Hilltop", name = "Hilltop Shrine", x = 0.52, y = 0.68, status = "active", season = "Beta" },
	{ id = "WolfDen", name = "Wolf Den", x = 0.42, y = 0.72, status = "active", season = "Beta" },
	{ id = "OakGrove", name = "Whispering Oak Grove", x = 0.35, y = 0.55, status = "active", season = "Beta" },
	{ id = "RuinedOutpost", name = "Ruined Outpost", x = 0.62, y = 0.58, status = "active", season = "Beta" },
	{ id = "RiverCrossing", name = "River Crossing", x = 0.50, y = 0.78, status = "active", season = "Beta" },
	{ id = "Mushfield", name = "Mushfield", x = 0.55, y = 0.65, status = "active", season = "Beta" },

	-- ===== SEASON 1: Foundations =====
	{ id = "IceKingdom", name = "Ice Kingdom", x = 0.25, y = 0.20, status = "coming", season = "S1" },
	{ id = "IceCity", name = "Ice City", x = 0.22, y = 0.18, status = "coming", season = "S1" },

	-- ===== SEASON 2: Courts & Conflict =====
	{ id = "FireKingdom", name = "Fire Kingdom", x = 0.78, y = 0.25, status = "coming", season = "S2" },
	{ id = "FlameCity", name = "Flame City", x = 0.82, y = 0.28, status = "coming", season = "S2" },
	{ id = "GoblinKingdom", name = "Goblin Kingdom", x = 0.70, y = 0.40, status = "coming", season = "S2" },

	-- ===== SEASON 3: Beyond Ooo =====
	{ id = "Nightosphere", name = "Nightosphere", x = 0.15, y = 0.75, status = "coming", season = "S3" },
	{ id = "DeadWorld", name = "Dead World", x = 0.12, y = 0.60, status = "coming", season = "S3" },
	{ id = "SlimeKingdom", name = "Slime Kingdom", x = 0.65, y = 0.75, status = "coming", season = "S3" },
	{ id = "WildberryKingdom", name = "Wildberry Kingdom", x = 0.72, y = 0.68, status = "coming", season = "S3" },

	-- ===== SEASON 4: Cosmic Horrors =====
	{ id = "PrismoTimeRoom", name = "Prismo's Time Room", x = 0.50, y = 0.10, status = "coming", season = "S4" },
	{ id = "CrystalCitadel", name = "Crystal Citadel", x = 0.88, y = 0.15, status = "coming", season = "S4" },
	{ id = "CloudKingdom", name = "Cloud Kingdom", x = 0.80, y = 0.55, status = "coming", season = "S4" },
	{ id = "LumpySpace", name = "Lumpy Space", x = 0.90, y = 0.45, status = "coming", season = "S4" },

	-- ===== SEASON 5: The Vault =====
	{ id = "Farmworld", name = "Farmworld", x = 0.10, y = 0.40, status = "future", season = "S5" },
	{ id = "PillowWorld", name = "Pillow World", x = 0.92, y = 0.70, status = "future", season = "S5" },
	{ id = "HotDogKingdom", name = "Hot Dog Kingdom", x = 0.30, y = 0.85, status = "future", season = "S5" },
	{ id = "TurtleKingdom", name = "Turtle Kingdom", x = 0.40, y = 0.92, status = "future", season = "S5" },
	{ id = "Lemongrab", name = "Lemongrab", x = 0.60, y = 0.90, status = "future", season = "S5" },

	-- ===== SEASON 6+: Eternal Ooo =====
	{ id = "Mars", name = "Mars", x = 0.05, y = 0.05, status = "future", season = "S6+" },
	{ id = "FoundersIsland", name = "Founders' Island", x = 0.95, y = 0.92, status = "future", season = "S6+" },
	{ id = "CosmicRealm", name = "Cosmic Realm", x = 0.50, y = 0.95, status = "future", season = "S6+" },
}

local STATUS_COLORS = {
	active = Theme.Colors.AccentGold,
	coming = Color3.fromRGB(140, 140, 160),
	future = Color3.fromRGB(80, 80, 100),
}

local function build()
	gui = UiUtil.makeScreenGui("MapScreen", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.85, 0, 0.85, 0),
		UDim2.new(0.075, 0, 0.075, 0),
		style.Panel,
		overlay
	)
	UiUtil.applyPanelStyle(panel, style)

	UiUtil.makeTitleBar(panel, "MAP OF OOO", style, function()
		MapScreen.Hide()
	end)

	-- Legend
	local legend = UiUtil.makeFrame("Legend", UDim2.new(0.4, 0, 0.05, 0), UDim2.new(0.03, 0, 0.11, 0), style.PanelAlt, panel)
	UiUtil.applyPanelStyle(legend, style)
	legend.BackgroundColor3 = style.PanelAlt

	UiUtil.makeLabel("LegendActive", "● Active", UDim2.new(0.33, 0, 1, 0), UDim2.new(0, 0, 0, 0), STATUS_COLORS.active, legend, Theme.Fonts.Header)
	UiUtil.makeLabel("LegendComing", "● Coming Soon", UDim2.new(0.33, 0, 1, 0), UDim2.new(0.33, 0, 0, 0), STATUS_COLORS.coming, legend, Theme.Fonts.Header)
	UiUtil.makeLabel("LegendFuture", "● Future", UDim2.new(0.33, 0, 1, 0), UDim2.new(0.66, 0, 0, 0), STATUS_COLORS.future, legend, Theme.Fonts.Header)

	-- Map area (placeholder: dark sea + stylized landmass block)
	local mapArea = UiUtil.makeFrame("MapArea", UDim2.new(0.94, 0, 0.76, 0), UDim2.new(0.03, 0, 0.19, 0), Color3.fromRGB(24, 34, 52), panel)
	UiUtil.applyPanelStyle(mapArea, style)
	mapArea.BackgroundColor3 = Color3.fromRGB(24, 34, 52)

	-- Stylized "Ooo" shape (placeholder — a long horizontal landmass)
	local landmass = UiUtil.makeFrame("Landmass", UDim2.new(0.9, 0, 0.5, 0), UDim2.new(0.05, 0, 0.25, 0), Color3.fromRGB(52, 66, 58), mapArea)
	landmass.BackgroundTransparency = 0.2

	-- Location pins: diamond marker + name label
	for _, loc in ipairs(LOCATIONS) do
		local color = STATUS_COLORS[loc.status]

		local pin = Instance.new("TextButton")
		pin.Name = loc.id
		pin.Size = UDim2.fromOffset(18, 18)
		pin.AnchorPoint = Vector2.new(0.5, 0.5)
		pin.Position = UDim2.fromScale(loc.x, loc.y)
		pin.Rotation = 45
		pin.BackgroundColor3 = color
		pin.BorderSizePixel = 0
		pin.Text = ""
		pin.AutoButtonColor = loc.status == "active"
		pin.Parent = mapArea

		local pinStroke = Instance.new("UIStroke")
		pinStroke.Color = Theme.Colors.PanelDark
		pinStroke.Thickness = 1
		pinStroke.Transparency = 0.3
		pinStroke.Parent = pin

		local nameLabel = UiUtil.makeLabel(
			"Label",
			loc.name,
			UDim2.new(0.14, 0, 0.04, 0),
			UDim2.new(loc.x - 0.07, 0, loc.y + 0.025, 0),
			color,
			mapArea,
			Theme.Fonts.Body
		)
		nameLabel.TextStrokeTransparency = 0.6

		pin.MouseButton1Click:Connect(function()
			if loc.status == "active" then
				local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
				if c2s and c2s:IsA("RemoteEvent") then
					c2s:FireServer("FastTravel", { shrineId = loc.id })
				end
				MapScreen.Hide()
			else
				-- Show "coming soon" feedback
				nameLabel.Text = loc.name .. " (" .. loc.season .. ")"
				task.delay(1.5, function()
					if nameLabel.Parent then
						nameLabel.Text = loc.name
					end
				end)
			end
		end)

		shrineButtons[loc.id] = pin
	end

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function MapScreen.Init(variant: string?)
	local newStyle = Theme.GetVariant(variant)
	if gui and newStyle == style then
		return
	end
	style = newStyle
	if gui then
		gui:Destroy()
		gui = nil
	end
	build()
end

function MapScreen.UnlockShrine(shrineId: string)
	local pin = shrineButtons[shrineId]
	if not pin then
		return
	end
	for _, loc in ipairs(LOCATIONS) do
		if loc.id == shrineId then
			loc.status = "active"
			pin.BackgroundColor3 = STATUS_COLORS.active
			pin.AutoButtonColor = true
			break
		end
	end
end

function MapScreen.Show()
	if not gui then
		MapScreen.Init()
	end
	gui.Enabled = true
end

function MapScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return MapScreen
