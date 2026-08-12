--!strict
-- Map / fast-travel screen — shows ALL planned locations.
-- Beta zones are interactable; post-beta zones are "coming soon" placeholders.
-- Lives in StarterPlayerScripts.Client.UI.MapScreen
--
-- Press M to open. Click a beta shrine to fast-travel.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local MapScreen = {}

local gui
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
	active = Color3.fromRGB(180, 220, 180),
	coming = Color3.fromRGB(140, 140, 160),
	future = Color3.fromRGB(80, 80, 100),
}

local STATUS_PREFIX = {
	active = "",
	coming = "🔒 ",
	future = "🔮 ",
}

local function build()
	gui = UiUtil.makeScreenGui("MapScreen", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.85, 0,  0.85, 0),
		UDim2.new(0.075, 0, 0.075, 0),
		Color3.fromRGB(25, 25, 40),
		overlay
	)

	UiUtil.makeLabel("Title", "MAP OF OOO", UDim2.new(1, 0, 0.06, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.04, 0, 0.05, 0), UDim2.new(0.95, 0, 0.015, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		MapScreen.Hide()
	end)

	-- Legend
	local legend = UiUtil.makeFrame("Legend", UDim2.new(0.4, 0, 0.05, 0), UDim2.new(0.03, 0, 0.10, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("LegendActive", "● Active", UDim2.new(0.33, 0, 1, 0), UDim2.new(0, 0, 0, 0), STATUS_COLORS.active, legend, Enum.Font.GothamBold)
	UiUtil.makeLabel("LegendComing", "● Coming Soon", UDim2.new(0.33, 0, 1, 0), UDim2.new(0.33, 0, 0, 0), STATUS_COLORS.coming, legend, Enum.Font.GothamBold)
	UiUtil.makeLabel("LegendFuture", "● Future", UDim2.new(0.33, 0, 1, 0), UDim2.new(0.66, 0, 0, 0), STATUS_COLORS.future, legend, Enum.Font.GothamBold)

	-- Map area
	local mapArea = UiUtil.makeFrame("MapArea", UDim2.new(0.94, 0, 0.78, 0), UDim2.new(0.03, 0, 0.18, 0), Color3.fromRGB(80, 130, 80), panel)

	-- Stylized "Ooo" shape (placeholder — a long horizontal landmass)
	local landmass = UiUtil.makeFrame("Landmass", UDim2.new(0.9, 0, 0.5, 0), UDim2.new(0.05, 0, 0.25, 0), Color3.fromRGB(140, 180, 110), mapArea)
	landmass.BackgroundTransparency = 0.3

	-- Location buttons
	for _, loc in ipairs(LOCATIONS) do
		local color = STATUS_COLORS[loc.status]
		local prefix = STATUS_PREFIX[loc.status]
		local btn = UiUtil.makeButton(
			loc.id,
			prefix .. loc.name,
			UDim2.new(0.13, 0, 0.05, 0),
			UDim2.new(loc.x - 0.065, 0, loc.y - 0.025, 0),
			color,
			mapArea
		)
		if loc.status ~= "active" then
			btn.Text = prefix .. loc.name .. " (S" .. loc.season .. ")"
		end
		btn.MouseButton1Click:Connect(function()
			if loc.status == "active" then
				local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
				if c2s and c2s:IsA("RemoteEvent") then
					c2s:FireServer("FastTravel", { shrineId = loc.id })
				end
				MapScreen.Hide()
			else
				-- Show "coming soon" feedback
				btn.Text = "Coming in " .. loc.season
				task.delay(1.5, function()
					btn.Text = prefix .. loc.name .. " (S" .. loc.season .. ")"
				end)
			end
		end)
		shrineButtons[loc.id] = btn
	end

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function MapScreen.UnlockShrine(shrineId: string)
	local btn = shrineButtons[shrineId]
	if btn then
		-- Find the location
		for _, loc in ipairs(LOCATIONS) do
			if loc.id == shrineId then
				loc.status = "active"
			end
		end
		if btn then
			btn.BackgroundColor3 = STATUS_COLORS.active
			btn.Text = btn.Text:gsub("🔒 ", "")
		end
	end
end

function MapScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
end

function MapScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return MapScreen
