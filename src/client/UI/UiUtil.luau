--!strict
-- UI utilities — shared helpers for building placeholder UI.
-- Lives in StarterPlayerScripts.Client.UI.UiUtil

local TweenService = game:GetService("TweenService")

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

-- Create a frame with rounded corners
function UiUtil.makeFrame(name: string, size: UDim2, position: UDim2, color: Color3, parent: Instance): Frame
	local f = Instance.new("Frame")
	f.Name = name
	f.Size = size
	f.Position = position
	f.BackgroundColor3 = color
	f.BorderSizePixel = 0
	f.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.05, 0)
	corner.Parent = f

	return f
end

-- Create a text button with rounded corners
function UiUtil.makeButton(name: string, text: string, size: UDim2, position: UDim2, color: Color3, parent: Instance): TextButton
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = size
	b.Position = position
	b.BackgroundColor3 = color
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextScaled = true
	b.AutoButtonColor = true
	b.BorderSizePixel = 0
	b.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = b

	return b
end

-- Create a text label
function UiUtil.makeLabel(name: string, text: string, size: UDim2, position: UDim2, color: Color3, parent: Instance, font: Enum.Font?): TextLabel
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Size = size
	l.Position = position
	l.BackgroundTransparency = 1
	l.Font = font or Enum.Font.GothamBold
	l.Text = text
	l.TextColor3 = color
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

-- Dark overlay (modal background)
function UiUtil.makeOverlay(parent: Instance): Frame
	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Parent = parent
	return overlay
end

return UiUtil
