--!strict
-- HUD system — health, stamina, hero meter, sugar meter, XP/level bar, gold.
-- Lives in StarterPlayerScripts.Client.HUD.HUDGui
--
-- Figma style: dark panels with gold accents; avatar circle + stacked bars on
-- the left, level/XP + gold top-right. Supports variants A (minimal),
-- B (medium frame), C (ornate frame + gems).
-- Placeholder visuals: colored bars + text. Real art swapped in later.
-- Reads from a client-side mirror of PlayerData (kept in sync via ServerToClient).

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UiUtil = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("UiUtil"))
local Theme = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("Theme"))

local HUD = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local bars = {} :: { [string]: { bg: Frame, fill: Frame, label: TextLabel } }

-- Smooth bar tween
local function setBarFill(bar: any, percent: number)
	if not bar or not bar.fill then
		return
	end
	percent = math.clamp(percent, 0, 1)
	local tween = TweenService:Create(
		bar.fill,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = UDim2.new(percent, 0, 1, 0) }
	)
	tween:Play()
end

local function makeBar(name: string, color: Color3, parent: Instance, layoutOrder: number)
	local row = Instance.new("Frame")
	row.Name = name .. "Row"
	row.Size = UDim2.new(1, 0, 0.16, 0)
	row.Position = UDim2.new(0, 0, 0, layoutOrder * 0.21)
	row.BackgroundTransparency = 1
	row.Parent = parent

	-- Icon placeholder (colored square with first letter — real icons later)
	local icon = Instance.new("Frame")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0.16, 0, 1, 0)
	icon.BackgroundColor3 = color
	icon.BorderSizePixel = 0
	icon.Parent = row

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0.25, 0)
	iconCorner.Parent = icon

	local iconLetter = Instance.new("TextLabel")
	iconLetter.Size = UDim2.fromScale(1, 1)
	iconLetter.BackgroundTransparency = 1
	iconLetter.Font = Theme.Fonts.Header
	iconLetter.Text = string.sub(name, 1, 1)
	iconLetter.TextColor3 = Theme.Colors.PanelDark
	iconLetter.TextScaled = true
	iconLetter.Parent = icon

	-- Bar track
	local frame = Instance.new("Frame")
	frame.Name = name .. "Bar"
	frame.Size = UDim2.new(0.8, 0, 1, 0)
	frame.Position = UDim2.new(0.2, 0, 0, 0)
	frame.BackgroundColor3 = Theme.Colors.PanelDark
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = row

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.4, 0)
	corner.Parent = frame

	if style.BorderThickness > 0 then
		local stroke = Instance.new("UIStroke")
		stroke.Color = style.Border
		stroke.Thickness = 1
		stroke.Transparency = math.max(style.BorderTransparency, 0.5)
		stroke.Parent = frame
	end

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = color
	fill.BorderSizePixel = 0
	fill.Parent = frame

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.4, 0)
	fillCorner.Parent = fill

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Theme.Fonts.Header
	label.Text = name
	label.TextColor3 = Theme.Colors.TextPrimary
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Parent = frame

	bars[name] = { bg = frame, fill = fill, label = label }
end

local function buildGui()
	gui = UiUtil.makeScreenGui("HUD", 50)

	-- Left-side panel: avatar + bars (health, stamina, hero, sugar)
	local leftPanel = UiUtil.makeFrame(
		"StatsPanel",
		UDim2.new(0.24, 0, 0.26, 0),
		UDim2.new(0.02, 0, 0.7, 0),
		style.Panel,
		gui
	)
	UiUtil.applyPanelStyle(leftPanel, style)

	-- Avatar circle placeholder
	local avatar = Instance.new("Frame")
	avatar.Name = "Avatar"
	avatar.Size = UDim2.new(0.26, 0, 0.42, 0)
	avatar.Position = UDim2.new(0.03, 0, 0.06, 0)
	avatar.BackgroundColor3 = style.Slot
	avatar.BorderSizePixel = 0
	avatar.Parent = leftPanel

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(0.5, 0)
	avatarCorner.Parent = avatar

	local avatarStroke = Instance.new("UIStroke")
	avatarStroke.Color = style.Accent
	avatarStroke.Thickness = math.max(style.BorderThickness, 1)
	avatarStroke.Transparency = style.BorderTransparency
	avatarStroke.Parent = avatar

	local avatarLabel = Instance.new("TextLabel")
	avatarLabel.Size = UDim2.fromScale(1, 1)
	avatarLabel.BackgroundTransparency = 1
	avatarLabel.Font = Theme.Fonts.Title
	avatarLabel.Text = "?"
	avatarLabel.TextColor3 = style.TitleColor
	avatarLabel.TextScaled = true
	avatarLabel.Parent = avatar

	-- Bars container (right of avatar)
	local barsHolder = Instance.new("Frame")
	barsHolder.Name = "Bars"
	barsHolder.Size = UDim2.new(0.66, 0, 0.9, 0)
	barsHolder.Position = UDim2.new(0.32, 0, 0.05, 0)
	barsHolder.BackgroundTransparency = 1
	barsHolder.Parent = leftPanel

	makeBar("Health", Theme.Colors.Health, barsHolder, 0)
	makeBar("Stamina", Theme.Colors.Stamina, barsHolder, 1)
	makeBar("Hero", Theme.Colors.Hero, barsHolder, 2)
	makeBar("Sugar", Theme.Colors.Sugar, barsHolder, 3)

	-- Top-right: level + XP bar + gold, in one framed panel
	local topRight = UiUtil.makeFrame(
		"ProgressPanel",
		UDim2.new(0.24, 0, 0.09, 0),
		UDim2.new(0.74, 0, 0.02, 0),
		style.Panel,
		gui
	)
	UiUtil.applyPanelStyle(topRight, style)

	-- Level badge (gold circle)
	local levelBadge = Instance.new("Frame")
	levelBadge.Name = "LevelBadge"
	levelBadge.Size = UDim2.new(0.16, 0, 0.7, 0)
	levelBadge.Position = UDim2.new(0.03, 0, 0.15, 0)
	levelBadge.BackgroundColor3 = Theme.Colors.AccentGold
	levelBadge.BorderSizePixel = 0
	levelBadge.Parent = topRight

	local badgeCorner = Instance.new("UICorner")
	badgeCorner.CornerRadius = UDim.new(0.5, 0)
	badgeCorner.Parent = levelBadge

	local levelLabel = Instance.new("TextLabel")
	levelLabel.Size = UDim2.fromScale(1, 1)
	levelLabel.BackgroundTransparency = 1
	levelLabel.Font = Theme.Fonts.Title
	levelLabel.Text = "1"
	levelLabel.TextColor3 = Theme.Colors.PanelDark
	levelLabel.TextScaled = true
	levelLabel.Parent = levelBadge

	-- XP bar
	local xpBar = Instance.new("Frame")
	xpBar.Name = "XPBar"
	xpBar.Size = UDim2.new(0.5, 0, 0.35, 0)
	xpBar.Position = UDim2.new(0.22, 0, 0.32, 0)
	xpBar.BackgroundColor3 = Theme.Colors.PanelDark
	xpBar.BorderSizePixel = 0
	xpBar.Parent = topRight

	local xpCorner = Instance.new("UICorner")
	xpCorner.CornerRadius = UDim.new(0.4, 0)
	xpCorner.Parent = xpBar

	local xpFill = Instance.new("Frame")
	xpFill.Size = UDim2.fromScale(0, 1)
	xpFill.BackgroundColor3 = Theme.Colors.XP
	xpFill.BorderSizePixel = 0
	xpFill.Parent = xpBar

	local xpFillCorner = Instance.new("UICorner")
	xpFillCorner.CornerRadius = UDim.new(0.4, 0)
	xpFillCorner.Parent = xpFill

	bars.Level = { bg = xpBar, fill = xpFill, label = levelLabel }

	-- Gold display
	local goldLabel = Instance.new("TextLabel")
	goldLabel.Name = "Gold"
	goldLabel.Size = UDim2.new(0.24, 0, 0.7, 0)
	goldLabel.Position = UDim2.new(0.74, 0, 0.15, 0)
	goldLabel.BackgroundTransparency = 1
	goldLabel.Font = Theme.Fonts.Header
	goldLabel.Text = "0 G"
	goldLabel.TextColor3 = Theme.Colors.AccentGold
	goldLabel.TextScaled = true
	goldLabel.Parent = topRight

	bars.Gold = { bg = topRight, fill = (nil :: any), label = goldLabel }

	-- Bottom-center: reputation tier (Candy Kingdom)
	local repPanel = UiUtil.makeFrame(
		"RepPanel",
		UDim2.new(0.16, 0, 0.045, 0),
		UDim2.new(0.42, 0, 0.94, 0),
		style.Panel,
		gui
	)
	UiUtil.applyPanelStyle(repPanel, style)

	local repLabel = Instance.new("TextLabel")
	repLabel.Size = UDim2.fromScale(1, 1)
	repLabel.BackgroundTransparency = 1
	repLabel.Font = Theme.Fonts.Header
	repLabel.Text = "Candy: Neutral"
	repLabel.TextColor3 = Theme.Colors.TextPrimary
	repLabel.TextScaled = true
	repLabel.Parent = repPanel

	bars.Reputation = { bg = repPanel, fill = (nil :: any), label = repLabel }

	-- Ornate corner gems (variant C)
	if style.Decorations then
		for _, parent in ipairs({ leftPanel, topRight }) do
			for _, pos in ipairs({ { 0.02, 0.08 }, { 0.98, 0.08 } }) do
				local gem = Instance.new("Frame")
				gem.Name = "Gem"
				gem.Size = UDim2.fromOffset(8, 8)
				gem.AnchorPoint = Vector2.new(0.5, 0.5)
				gem.Position = UDim2.fromScale(pos[1], pos[2])
				gem.Rotation = 45
				gem.BackgroundColor3 = style.Accent
				gem.BorderSizePixel = 0
				gem.Parent = parent
			end
		end
	end
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function HUD.Init(variant: string?)
	local newStyle = Theme.GetVariant(variant)
	if gui and newStyle == style then
		return
	end
	style = newStyle
	if gui then
		gui:Destroy()
		gui = nil
	end
	buildGui()
	gui.Enabled = false
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Public API for other client systems to update HUD
function HUD.UpdateHealth(current: number, max: number)
	if not bars.Health then
		return
	end
	setBarFill(bars.Health, current / max)
	bars.Health.label.Text = ("HP %d / %d"):format(current, max)
end

function HUD.UpdateStamina(current: number, max: number)
	if not bars.Stamina then
		return
	end
	setBarFill(bars.Stamina, current / max)
	bars.Stamina.label.Text = ("STA %d / %d"):format(current, max)
end

function HUD.UpdateHero(current: number)
	if not bars.Hero then
		return
	end
	setBarFill(bars.Hero, current / 100)
	bars.Hero.label.Text = ("HERO %d%%"):format(current)
	-- Gold glow when full
	if current >= 100 then
		bars.Hero.bg.BackgroundColor3 = Color3.fromRGB(90, 70, 25)
	else
		bars.Hero.bg.BackgroundColor3 = Theme.Colors.PanelDark
	end
end

function HUD.UpdateSugar(current: number, tier: number)
	if not bars.Sugar then
		return
	end
	setBarFill(bars.Sugar, current / 10)
	bars.Sugar.label.Text = ("SUGAR T%d"):format(tier)
	-- Pinker as tier rises
	local color = Color3.fromRGB(255, 120 + tier * 30, 200 - tier * 40)
	bars.Sugar.fill.BackgroundColor3 = color
end

function HUD.UpdateLevel(level: number, xp: number, xpToNext: number)
	if not bars.Level then
		return
	end
	setBarFill(bars.Level, xp / xpToNext)
	bars.Level.label.Text = tostring(level)
end

function HUD.UpdateGold(gold: number)
	if not bars.Gold or not bars.Gold.label then
		return
	end
	bars.Gold.label.Text = ("%d G"):format(gold)
end

function HUD.UpdateReputation(tier: string, _value: number)
	if not bars.Reputation or not bars.Reputation.label then
		return
	end
	bars.Reputation.label.Text = ("Candy: %s"):format(tier)
	-- Color by tier
	local colors = {
		Beloved = Color3.fromRGB(80, 220, 120),
		Liked = Color3.fromRGB(120, 200, 80),
		Neutral = Theme.Colors.TextPrimary,
		Disliked = Color3.fromRGB(240, 180, 80),
		Wanted = Color3.fromRGB(240, 80, 80),
		Hunted = Color3.fromRGB(200, 40, 40),
	}
	bars.Reputation.label.TextColor3 = colors[tier] or Theme.Colors.TextPrimary
end

function HUD.Show()
	if not gui then
		HUD.Init()
	end
	gui.Enabled = true
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function HUD.Hide()
	if gui then
		gui.Enabled = false
	end
end

return HUD
