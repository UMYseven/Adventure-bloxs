--!strict
-- Settings screen — audio sliders, graphics, gameplay + accessibility toggles.
-- Lives in StarterPlayerScripts.Client.UI.SettingsScreen
--
-- Figma style: framed panel with gold section headers, slider rows with
-- fill bars, ON/OFF toggle pills. Supports variants A/B/C.
-- Placeholder visuals: colored frames + text. Persistence comes later.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local SettingsScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)

local settings = {
	masterVolume = 1,
	musicVolume = 0.8,
	sfxVolume = 1,
	graphicsQuality = "Medium",
	cameraLockOn = false,
	autoTarget = false,
	friendlyFire = false,
	nightosphereMode = false,
}

local QUALITY_LEVELS = { "Low", "Medium", "High" }

-- Section header with gold text (matches the Figma section labels)
local function makeSection(parent: Instance, name: string, title: string, yPos: number, height: number): Frame
	local section = UiUtil.makeFrame(
		name,
		UDim2.new(0.9, 0, height, 0),
		UDim2.new(0.05, 0, yPos, 0),
		style.PanelAlt,
		parent
	)
	UiUtil.applyPanelStyle(section, style)
	section.BackgroundColor3 = style.PanelAlt

	local titleLabel = UiUtil.makeLabel(
		"Title",
		title,
		UDim2.new(0.9, 0, 0.14, 0),
		UDim2.new(0.05, 0, 0.02, 0),
		style.Accent,
		section,
		Theme.Fonts.Header
	)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	return section
end

-- Slider row: label + track + fill + value. Click/drag on the track sets value.
local function makeSlider(parent: Instance, key: string, label: string, yPos: number)
	UiUtil.makeLabel(
		key .. "Label",
		label,
		UDim2.new(0.3, 0, 0.22, 0),
		UDim2.new(0.05, 0, yPos, 0),
		Theme.Colors.TextSecondary,
		parent,
		Theme.Fonts.Body
	).TextXAlignment = Enum.TextXAlignment.Left

	local track = Instance.new("TextButton")
	track.Name = key .. "Track"
	track.Size = UDim2.new(0.42, 0, 0.1, 0)
	track.Position = UDim2.new(0.38, 0, yPos + 0.05, 0)
	track.BackgroundColor3 = Theme.Colors.PanelDark
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = parent

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0.5, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(settings[key], 1)
	fill.BackgroundColor3 = Theme.Colors.AccentGold
	fill.BorderSizePixel = 0
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = fill

	local valueLabel = UiUtil.makeLabel(
		key .. "Value",
		("%d%%"):format(math.floor(settings[key] * 100 + 0.5)),
		UDim2.new(0.12, 0, 0.22, 0),
		UDim2.new(0.83, 0, yPos, 0),
		style.Accent,
		parent,
		Theme.Fonts.Header
	)

	local function setValue(v: number)
		v = math.clamp(v, 0, 1)
		settings[key] = v
		fill.Size = UDim2.fromScale(v, 1)
		valueLabel.Text = ("%d%%"):format(math.floor(v * 100 + 0.5))
	end

	local dragging = false
	local function setFromX(absX: number)
		local rel = (absX - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
		setValue(rel)
	end

	track.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	track.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input: InputObject, _processed: boolean)
		if not track.Parent then
			dragging = false
			return
		end
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and gui and gui.Enabled then
			setFromX(input.Position.X)
		end
	end)
end

-- ON/OFF toggle pill row
local function makeToggle(parent: Instance, key: string, label: string, yPos: number)
	UiUtil.makeLabel(
		key .. "Label",
		label,
		UDim2.new(0.6, 0, 0.2, 0),
		UDim2.new(0.05, 0, yPos, 0),
		Theme.Colors.TextSecondary,
		parent,
		Theme.Fonts.Body
	).TextXAlignment = Enum.TextXAlignment.Left

	local btn = UiUtil.makeButton(
		key,
		"OFF",
		UDim2.new(0.16, 0, 0.2, 0),
		UDim2.new(0.78, 0, yPos, 0),
		Theme.Colors.PanelDark,
		parent
	)
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = style.Border
	btnStroke.Thickness = 1
	btnStroke.Transparency = 0.5
	btnStroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		settings[key] = not settings[key]
		btn.Text = if settings[key] then "ON" else "OFF"
		btn.BackgroundColor3 = if settings[key] then Theme.Colors.AccentGold else Theme.Colors.PanelDark
		btn.TextColor3 = if settings[key] then Theme.Colors.PanelDark else Theme.Colors.TextSecondary
	end)
end

local function build()
	gui = UiUtil.makeScreenGui("Settings", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.5, 0, 0.84, 0),
		UDim2.new(0.25, 0, 0.08, 0),
		style.Panel,
		overlay
	)
	UiUtil.applyPanelStyle(panel, style)

	UiUtil.makeTitleBar(panel, "SETTINGS", style, function()
		SettingsScreen.Hide()
	end)

	-- Audio section: 3 sliders
	local audioSection = makeSection(panel, "Audio", "AUDIO", 0.12, 0.26)
	makeSlider(audioSection, "masterVolume", "Master Volume", 0.2)
	makeSlider(audioSection, "musicVolume", "Music Volume", 0.5)
	makeSlider(audioSection, "sfxVolume", "SFX Volume", 0.8)

	-- Graphics section: quality cycler
	local graphicsSection = makeSection(panel, "Graphics", "GRAPHICS", 0.42, 0.14)
	UiUtil.makeLabel(
		"QualityLabel",
		"Quality",
		UDim2.new(0.3, 0, 0.5, 0),
		UDim2.new(0.05, 0, 0.35, 0),
		Theme.Colors.TextSecondary,
		graphicsSection,
		Theme.Fonts.Body
	).TextXAlignment = Enum.TextXAlignment.Left

	local qualityBtn = UiUtil.makeButton(
		"Quality",
		settings.graphicsQuality,
		UDim2.new(0.3, 0, 0.5, 0),
		UDim2.new(0.55, 0, 0.35, 0),
		style.ButtonColor,
		graphicsSection
	)
	qualityBtn.MouseButton1Click:Connect(function()
		local idx = table.find(QUALITY_LEVELS, settings.graphicsQuality) or 2
		idx = (idx % #QUALITY_LEVELS) + 1
		settings.graphicsQuality = QUALITY_LEVELS[idx]
		qualityBtn.Text = settings.graphicsQuality
	end)

	-- Gameplay + accessibility toggles
	local togglesSection = makeSection(panel, "Toggles", "GAMEPLAY & ACCESSIBILITY", 0.6, 0.34)
	makeToggle(togglesSection, "cameraLockOn", "Camera Lock-On", 0.16)
	makeToggle(togglesSection, "autoTarget", "Auto-Target (Mobile)", 0.4)
	makeToggle(togglesSection, "friendlyFire", "Friendly Fire", 0.64)
	makeToggle(togglesSection, "nightosphereMode", "Nightosphere Mode (18+)", 0.88)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function SettingsScreen.Init(variant: string?)
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

function SettingsScreen.Show()
	if not gui then
		SettingsScreen.Init()
	end
	gui.Enabled = true
end

function SettingsScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

function SettingsScreen.Get()
	return settings
end

return SettingsScreen
