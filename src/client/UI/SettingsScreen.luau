--!strict
-- Settings screen — audio, graphics, controls, accessibility toggles.
-- Lives in StarterPlayerScripts.Client.UI.SettingsScreen

local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local SettingsScreen = {}

local gui
local settings = {
	masterVolume = 1,
	musicVolume = 0.8,
	sfxVolume = 1,
	graphicsQuality = "Medium",
	cameraLockOn = false,
	autoTarget = false,
	friendlyFire = false,
	nightosphereMode = false,
	colorblindPalette = "Off",
}

local function build()
	gui = UiUtil.makeScreenGui("Settings", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.5, 0, 0.8, 0),
		UDim2.new(0.25, 0, 0.1, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "SETTINGS", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		SettingsScreen.Hide()
	end)

	-- Audio section
	local audioSection = UiUtil.makeFrame("Audio", UDim2.new(0.9, 0, 0.25, 0), UDim2.new(0.05, 0, 0.12, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("AudioTitle", "AUDIO", UDim2.new(1, 0, 0.15, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(120, 200, 200), audioSection, Enum.Font.GothamBold)

	-- Graphics section
	local graphicsSection = UiUtil.makeFrame("Graphics", UDim2.new(0.9, 0, 0.25, 0), UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("GraphicsTitle", "GRAPHICS", UDim2.new(1, 0, 0.15, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(120, 200, 200), graphicsSection, Enum.Font.GothamBold)

	-- Accessibility section
	local accessSection = UiUtil.makeFrame("Accessibility", UDim2.new(0.9, 0, 0.3, 0), UDim2.new(0.05, 0, 0.68, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("AccessTitle", "ACCESSIBILITY", UDim2.new(1, 0, 0.12, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(120, 200, 200), accessSection, Enum.Font.GothamBold)

	-- Toggle buttons for accessibility
	local toggles = {
		{ "cameraLockOn", "Camera Lock-On", false },
		{ "autoTarget", "Auto-Target (Mobile)", false },
		{ "friendlyFire", "Friendly Fire", false },
		{ "nightosphereMode", "Nightosphere Mode (18+)", false },
	}
	for i, t in ipairs(toggles) do
		local btn = UiUtil.makeButton(t[1], t[2] .. ": OFF", UDim2.new(0.9, 0, 0.18, 0), UDim2.new(0.05, 0, 0.15 + (i - 1) * 0.2, 0), Color3.fromRGB(60, 60, 80), accessSection)
		btn.MouseButton1Click:Connect(function()
			settings[t[1]] = not settings[t[1]]
			btn.Text = t[2] .. ": " .. (settings[t[1]] and "ON" or "OFF")
			btn.BackgroundColor3 = settings[t[1]] and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 80)
		end)
	end

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function SettingsScreen.Show()
	if not gui then
		build()
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
