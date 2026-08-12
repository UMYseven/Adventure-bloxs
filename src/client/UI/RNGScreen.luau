--!strict
-- Client RNG screen — shown when player's data loads with firstSpawn = true.
-- Lives in StarterPlayerScripts.Client.UI.RNGScreen
--
-- Flow:
--   1. Listen for ServerToClient (RNGResult) carrying the roll.
--   2. Show a "rolling" animation (3 spins landing on race/bloodline/talent).
--   3. Reveal the result with rarity colors.
--   4. "Begin Adventure" button → fires ClientToServer (ConfirmRNG) → server
--      marks firstSpawn = false and spawns the player in Candy Kingdom.
--
-- Placeholder visuals: text + colored frames. Real art swapped in later.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"):WaitForChild("GameConstants"))

local RACES = Constants.RACES
local BLOODLINES = Constants.BLOODLINES
local TALENTS = Constants.TALENTS

local TIER_COLORS = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(80, 200, 80),
	Rare = Color3.fromRGB(80, 140, 240),
	Epic = Color3.fromRGB(180, 80, 240),
	Legendary = Color3.fromRGB(240, 180, 60),
	Mythic = Color3.fromRGB(240, 60, 60),
}

local RNGScreen = {}

local screenGui
local rollFrames = {} :: { [string]: Frame }
local revealed = false

local function makeLabel(text: string, _size: number, parent: Instance): TextLabel
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBold
	l.Text = text
	l.TextColor3 = Color3.fromRGB(255, 255, 255)
	l.TextScaled = true
	l.Parent = parent
	return l
end

-- Build the placeholder screen GUI
local function buildGui()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RNGScreen"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 100

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	bg.BackgroundTransparency = 0.1
	bg.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0.2, 0.5, 0)
	title.Position = UDim2.new(0, 0, 0.05, 0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBlack
	title.Text = "THE TIMELINE HAS FRACTURED..."
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Parent = bg

	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0.15, 0.5, 0)
	subtitle.Position = UDim2.new(0, 0, 0.22, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = "Prismo pulls you into existence. Who are you?"
	subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
	subtitle.TextScaled = true
	subtitle.Parent = bg

	-- Three roll frames: race / bloodline / talent
	local labels = { "RACE", "BLOODLINE", "TALENT" }
	for i, label in ipairs(labels) do
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0.28, 0, 0.25, 0)
		frame.Position = UDim2.new(0.04 + (i - 1) * 0.32, 0, 0.45, 0)
		frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
		frame.BorderSizePixel = 0
		frame.Parent = bg

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0.05, 0)
		corner.Parent = frame

		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, 0, 0.25, 0)
		header.BackgroundTransparency = 1
		header.Font = Enum.Font.GothamBold
		header.Text = label
		header.TextColor3 = Color3.fromRGB(180, 180, 200)
		header.TextScaled = true
		header.Parent = frame

		local valueLabel = makeLabel("...", 24, frame)
		valueLabel.Position = UDim2.new(0, 0, 0.25, 0)
		valueLabel.Size = UDim2.new(1, 0, 0.55, 0)

		local tierLabel = makeLabel("", 18, frame)
		tierLabel.Position = UDim2.new(0, 0, 0.8, 0)
		tierLabel.Size = UDim2.new(1, 0, 0.2, 0)
		tierLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

		rollFrames[label] = frame
		rollFrames[label .. "_value"] = valueLabel
		rollFrames[label .. "_tier"] = tierLabel
	end

	-- Begin Adventure button
	local beginBtn = Instance.new("TextButton")
	beginBtn.Size = UDim2.new(0.3, 0, 0.1, 0)
	beginBtn.Position = UDim2.new(0.35, 0, 0.78, 0)
	beginBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
	beginBtn.Text = "BEGIN ADVENTURE"
	beginBtn.Font = Enum.Font.GothamBlack
	beginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	beginBtn.TextScaled = true
	beginBtn.AutoButtonColor = false
	beginBtn.Visible = false
	beginBtn.Parent = bg

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = beginBtn

	beginBtn.MouseButton1Click:Connect(function()
		if not revealed then
			return
		end
		beginBtn.Visible = false
		-- Tell server we confirmed
		local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
		if c2s and c2s:IsA("RemoteEvent") then
			c2s:FireServer("ConfirmRNG")
		end
		-- Fade out screen
		local fade = TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
		fade:Play()
		fade.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	rollFrames._beginBtn = beginBtn
end

-- Animate a single roll frame: cycle through random values, then land on the final.
local function animateRoll(slot: string, pool: { string }, finalId: string, finalLabel: string, finalColor: Color3)
	local frame = rollFrames[slot]
	local valueLabel = rollFrames[slot .. "_value"] :: TextLabel
	local tierLabel = rollFrames[slot .. "_tier"] :: TextLabel

	local cycles = 8
	for i = 1, cycles do
		task.spawn(function()
			task.wait(i * 0.08)
			local sample = pool[math.random(1, #pool)]
			valueLabel.Text = sample
			frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
		end)
	end

	task.delay(cycles * 0.08 + 0.2, function()
		valueLabel.Text = finalLabel or finalId
		frame.BackgroundColor3 = finalColor
		tierLabel.TextColor3 = finalColor
		tierLabel.Text = string.upper(RACES[finalId] and RACES[finalId].tier or "")
	end)
end

-- Show the screen with a roll result.
function RNGScreen.Show(roll: { race: string, bloodline: string, talent: string })
	if not screenGui then
		buildGui()
	end
	screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	revealed = false
	rollFrames._beginBtn.Visible = false

	-- Build pools for the animation
	local racePool = {}
	for id, _ in pairs(RACES) do
		table.insert(racePool, id)
	end
	local bloodlinePool = {}
	for id, _ in pairs(BLOODLINES) do
		table.insert(bloodlinePool, id)
	end

	-- Final colors
	local raceDef = RACES[roll.race]
	local raceColor = raceDef and TIER_COLORS[raceDef.tier] or Color3.fromRGB(255, 255, 255)
	local bloodlineDef = BLOODLINES[roll.bloodline]
	local bloodlineColor = bloodlineDef and TIER_COLORS[bloodlineDef.tier] or Color3.fromRGB(255, 255, 255)
	local talentColor = Color3.fromRGB(200, 200, 220)

	-- Animate all three in parallel
	animateRoll("RACE", racePool, roll.race, raceDef and raceDef.name or roll.race, raceColor)
	animateRoll("BLOODLINE", bloodlinePool, roll.bloodline, roll.bloodline, bloodlineColor)
	animateRoll("TALENT", TALENTS, roll.talent, roll.talent, talentColor)

	-- Reveal begin button after all animations land
	task.delay(1.5, function()
		revealed = true
		rollFrames._beginBtn.Visible = true
	end)
end

return RNGScreen
