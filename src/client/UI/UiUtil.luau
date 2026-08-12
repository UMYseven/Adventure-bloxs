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

-- Apply a variant style (from Theme.GetVariant) to a panel frame:
-- background color, corner radius, and a gold UIStroke border when the
-- variant calls for one (B = thin/faded, C = thick/solid, A = none).
function UiUtil.applyPanelStyle(frame: GuiObject, style: any)
	frame.BackgroundColor3 = style.Panel

	local corner = frame:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = frame
	end
	corner.CornerRadius = style.CornerRadius

	local stroke = frame:FindFirstChildOfClass("UIStroke")
	if style.BorderThickness > 0 then
		if not stroke then
			stroke = Instance.new("UIStroke")
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = frame
		end
		stroke.Color = style.Border
		stroke.Thickness = style.BorderThickness
		stroke.Transparency = style.BorderTransparency
	elseif stroke then
		stroke:Destroy()
	end
end

-- Small rotated gold square used as an ornate corner accent (variant C).
local function makeGem(parent: Instance, xScale: number, yScale: number, size: number, color: Color3)
	local gem = Instance.new("Frame")
	gem.Name = "Gem"
	gem.Size = UDim2.fromOffset(size, size)
	gem.AnchorPoint = Vector2.new(0.5, 0.5)
	gem.Position = UDim2.fromScale(xScale, yScale)
	gem.Rotation = 45
	gem.BackgroundColor3 = color
	gem.BorderSizePixel = 0
	gem.Parent = parent
end

-- Standard screen header: centered gold title, red X close button, plus the
-- variant's extras (gold underline for B/C, corner gems for C).
function UiUtil.makeTitleBar(panel: Instance, title: string, style: any, onClose: (() -> ())?)
	UiUtil.makeLabel(
		"Title",
		title,
		UDim2.new(0.6, 0, 0.08, 0),
		UDim2.new(0.2, 0, 0.02, 0),
		style.TitleColor,
		panel,
		Theme.Fonts.Title
	)

	if style.Underline then
		local line = Instance.new("Frame")
		line.Name = "TitleUnderline"
		line.Size = UDim2.new(0.34, 0, 0.006, 0)
		line.Position = UDim2.new(0.33, 0, 0.095, 0)
		line.BackgroundColor3 = style.Accent
		line.BorderSizePixel = 0
		line.Parent = panel

		local lineCorner = Instance.new("UICorner")
		lineCorner.CornerRadius = UDim.new(0.5, 0)
		lineCorner.Parent = line
	end

	if style.Decorations then
		makeGem(panel, 0.03, 0.045, 10, style.Accent)
		makeGem(panel, 0.97, 0.045, 10, style.Accent)
	end

	if onClose then
		local closeBtn = UiUtil.makeButton(
			"Close",
			"X",
			UDim2.new(0.06, 0, 0.055, 0),
			UDim2.new(0.915, 0, 0.02, 0),
			Theme.Colors.AccentRed,
			panel
		)
		closeBtn.MouseButton1Click:Connect(onClose)
	end
end

return UiUtil
