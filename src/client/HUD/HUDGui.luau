--!strict
-- HUD system — health, stamina, hero meter, sugar meter, XP/level bar.
-- Lives in StarterPlayerScripts.Client.HUD.HUDGui
--
-- Placeholder visuals: colored bars + text. Real art swapped in later.
-- Reads from a client-side mirror of PlayerData (kept in sync via ServerToClient).

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local HUD = {}

local gui
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
	local frame = Instance.new("Frame")
	frame.Name = name .. "Bar"
	frame.Size = UDim2.new(0.22, 0, 0.04, 0)
	frame.Position = UDim2.new(0.02, 0, 0, layoutOrder * 0.06)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.4, 0)
	corner.Parent = frame

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
	label.Font = Enum.Font.GothamBold
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Parent = frame

	bars[name] = { bg = frame, fill = fill, label = label }
end

local function buildGui()
	gui = Instance.new("ScreenGui")
	gui.Name = "HUD"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 50

	-- Left-side bars (health, stamina, hero, sugar)
	local leftPanel = Instance.new("Frame")
	leftPanel.Size = UDim2.new(0.3, 0, 0.3, 0)
	leftPanel.Position = UDim2.new(0, 0, 0.7, 0)
	leftPanel.BackgroundTransparency = 1
	leftPanel.Parent = gui

	makeBar("Health", Color3.fromRGB(220, 60, 60), leftPanel, 0)
	makeBar("Stamina", Color3.fromRGB(120, 200, 80), leftPanel, 1)
	makeBar("Hero", Color3.fromRGB(240, 180, 60), leftPanel, 2)
	makeBar("Sugar", Color3.fromRGB(255, 120, 200), leftPanel, 3)

	-- Top-right: level + XP bar
	local topRight = Instance.new("Frame")
	topRight.Size = UDim2.new(0.25, 0, 0.06, 0)
	topRight.Position = UDim2.new(0.73, 0, 0.02, 0)
	topRight.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	topRight.BackgroundTransparency = 0.2
	topRight.BorderSizePixel = 0
	topRight.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.4, 0)
	corner.Parent = topRight

	local xpFill = Instance.new("Frame")
	xpFill.Size = UDim2.fromScale(0, 1)
	xpFill.BackgroundColor3 = Color3.fromRGB(100, 180, 240)
	xpFill.BorderSizePixel = 0
	xpFill.Parent = topRight

	local xpCorner = Instance.new("UICorner")
	xpCorner.CornerRadius = UDim.new(0.4, 0)
	xpCorner.Parent = xpFill

	local levelLabel = Instance.new("TextLabel")
	levelLabel.Size = UDim2.new(0.3, 1, 1, 0)
	levelLabel.BackgroundTransparency = 1
	levelLabel.Font = Enum.Font.GothamBlack
	levelLabel.Text = "Lv 1"
	levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	levelLabel.TextScaled = true
	levelLabel.Parent = topRight

	bars.Level = { bg = topRight, fill = xpFill, label = levelLabel }

	-- Bottom-center: gold + reputation tier (Candy Kingdom)
	local bottomCenter = Instance.new("Frame")
	bottomCenter.Size = UDim2.new(0.3, 0, 0.05, 0)
	bottomCenter.Position = UDim2.new(0.35, 0, 0.94, 0)
	bottomCenter.BackgroundTransparency = 1
	bottomCenter.Parent = gui

	local goldLabel = Instance.new("TextLabel")
	goldLabel.Size = UDim2.new(0.5, 1, 1, 0)
	goldLabel.BackgroundTransparency = 1
	goldLabel.Font = Enum.Font.GothamBold
	goldLabel.Text = "Gold: 0"
	goldLabel.TextColor3 = Color3.fromRGB(240, 200, 80)
	goldLabel.TextScaled = true
	goldLabel.Parent = bottomCenter

	local repLabel = Instance.new("TextLabel")
	repLabel.Size = UDim2.new(0.5, 1, 1, 0)
	repLabel.Position = UDim2.new(0.5, 0, 0, 0)
	repLabel.BackgroundTransparency = 1
	repLabel.Font = Enum.Font.GothamBold
	repLabel.Text = "Candy: Neutral"
	repLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	repLabel.TextScaled = true
	repLabel.Parent = bottomCenter

	bars.Gold = { bg = bottomCenter, fill = (nil :: any), label = goldLabel }
	bars.Reputation = { bg = bottomCenter, fill = (nil :: any), label = repLabel }
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
		bars.Hero.bg.BackgroundColor3 = Color3.fromRGB(80, 60, 20)
	else
		bars.Hero.bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
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
	bars.Level.label.Text = ("Lv %d"):format(level)
end

function HUD.UpdateGold(gold: number)
	if not bars.Gold or not bars.Gold.label then
		return
	end
	bars.Gold.label.Text = ("Gold: %d"):format(gold)
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
		Neutral = Color3.fromRGB(255, 255, 255),
		Disliked = Color3.fromRGB(240, 180, 80),
		Wanted = Color3.fromRGB(240, 80, 80),
		Hunted = Color3.fromRGB(200, 40, 40),
	}
	bars.Reputation.label.TextColor3 = colors[tier] or Color3.fromRGB(255, 255, 255)
end

function HUD.Show()
	if not gui then
		buildGui()
	end
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function HUD.Hide()
	if gui then
		gui.Parent = nil
	end
end

return HUD
