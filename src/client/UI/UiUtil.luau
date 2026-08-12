--!strict
-- UI utilities — shared helpers for building placeholder UI, themed consistently.
-- Lives in StarterPlayerScripts.Client.UI.UiUtil

local TweenService = game:GetService("TweenService")

local Theme = require(script.Parent:WaitForChild("Theme"))

local UiUtil = {}

-- Create a ScreenGui with sensible defaults
function UiUtil.makeScreenGui(name: string, displayOrder: number): ScreenGui
	local g = Instance.new("ScreenGui")
	g.Name = name
	g.IgnoreGuiInset = true
	g.ResetOnSpawn = false
	g.DisplayOrder = displayOrder
	return g
end

-- Create a frame with rounded corners (themed)
function UiUtil.makeFrame(name: string, size: UDim2, position: UDim2, color: Color3?, parent: Instance): Frame
	local f = Instance.new("Frame")
	f.Name = name
	f.Size = size
	f.Position = position
	f.BackgroundColor3 = color or Theme.Colors.Panel
	f.BorderSizePixel = 0
	f.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.Sizes.CornerRadius
	corner.Parent = f

	return f
end

-- Create a text button with rounded corners (themed)
function UiUtil.makeButton(name: string, text: string, size: UDim2, position: UDim2, color: Color3?, parent: Instance): TextButton
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = size
	b.Position = position
	b.BackgroundColor3 = color or Theme.Colors.AccentGreen
	b.Text = text
	b.Font = Theme.Fonts.Header
	b.TextColor3 = Theme.Colors.TextPrimary
	b.TextScaled = true
	b.AutoButtonColor = true
	b.BorderSizePixel = 0
	b.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.Sizes.ButtonCornerRadius
	corner.Parent = b

	return b
end

-- Create a text label (themed)
function UiUtil.makeLabel(name: string, text: string, size: UDim2, position: UDim2, color: Color3?, parent: Instance, font: Enum.Font?): TextLabel
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Size = size
	l.Position = position
	l.BackgroundTransparency = 1
	l.Font = font or Theme.Fonts.Header
	l.Text = text
	l.TextColor3 = color or Theme.Colors.TextPrimary
	l.TextScaled = true
	l.Parent = parent
	return l
end

-- Fade a GUI in/out
function UiUtil.fade(gui: GuiObject, targetTransparency: number, duration: number?)
	local tween = TweenService:Create(
		gui,
		TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = targetTransparency }
	)
	tween:Play()
	return tween
end

-- Dark overlay (modal background, themed)
function UiUtil.makeOverlay(parent: Instance): Frame
	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Theme.Colors.Overlay
	overlay.BackgroundTransparency = Theme.Transparency.Overlay
	overlay.BorderSizePixel = 0
	overlay.Parent = parent
	return overlay
end

return UiUtil
