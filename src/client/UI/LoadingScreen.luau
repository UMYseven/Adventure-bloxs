--!strict
-- Loading screen — shown while preloading all assets, before RNG character creation.
-- Lives in StarterPlayerScripts.Client.UI.LoadingScreen
--
-- Flow: Player joins → LoadingScreen shows → ContentProvider preloads all assets →
--   LoadingScreen fades → RNGScreen shows (if firstSpawn) → player spawns in Candy Kingdom.
--
-- Placeholder visuals: dark background + logo + progress bar + status text.

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoadingScreen = {}

local gui
local progressFill
local progressLabel
local statusLabel

local function build()
	gui = Instance.new("ScreenGui")
	gui.Name = "LoadingScreen"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 200 -- above everything else

	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	bg.BorderSizePixel = 0
	bg.Parent = gui

	-- Logo placeholder
	local logo = Instance.new("TextLabel")
	logo.Name = "Logo"
	logo.Size = UDim2.new(0.6, 0, 0.15, 0)
	logo.Position = UDim2.new(0.2, 0, 0.15, 0)
	logo.BackgroundTransparency = 1
	logo.Font = Enum.Font.GothamBlack
	logo.Text = "ADVENTURE TIME: OOO"
	logo.TextColor3 = Color3.fromRGB(255, 200, 80)
	logo.TextScaled = true
	logo.Parent = bg

	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Size = UDim2.new(0.6, 0, 0.08, 0)
	subtitle.Position = UDim2.new(0.2, 0, 0.32, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Enum.Font.GothamMedium
	subtitle.Text = "The timeline has fractured..."
	subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
	subtitle.TextScaled = true
	subtitle.Parent = bg

	-- Progress bar background
	local progressBg = Instance.new("Frame")
	progressBg.Name = "ProgressBg"
	progressBg.Size = UDim2.new(0.5, 0, 0.04, 0)
	progressBg.Position = UDim2.new(0.25, 0, 0.5, 0)
	progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	progressBg.BorderSizePixel = 0
	progressBg.Parent = bg

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.5, 0)
	corner.Parent = progressBg

	-- Progress bar fill
	progressFill = Instance.new("Frame")
	progressFill.Name = "Fill"
	progressFill.Size = UDim2.fromScale(0, 1)
	progressFill.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
	progressFill.BorderSizePixel = 0
	progressFill.Parent = progressBg

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = progressFill

	-- Progress label
	progressLabel = Instance.new("TextLabel")
	progressLabel.Name = "Progress"
	progressLabel.Size = UDim2.new(0.5, 0, 0.03, 0)
	progressLabel.Position = UDim2.new(0.25, 0, 0.56, 0)
	progressLabel.BackgroundTransparency = 1
	progressLabel.Font = Enum.Font.GothamBold
	progressLabel.Text = "Loading... 0%"
	progressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	progressLabel.TextScaled = true
	progressLabel.Parent = bg

	-- Status label (what's currently loading)
	statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "Status"
	statusLabel.Size = UDim2.new(0.6, 0, 0.04, 0)
	statusLabel.Position = UDim2.new(0.2, 0, 0.62, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.Text = "Initializing..."
	statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
	statusLabel.TextScaled = true
	statusLabel.Parent = bg

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Update progress (0 to 1)
local function setProgress(percent: number)
	if not gui then
		return
	end
	percent = math.clamp(percent, 0, 1)
	progressFill.Size = UDim2.fromScale(percent, 1)
	progressLabel.Text = ("Loading... %d%%"):format(math.floor(percent * 100))
end

-- Update status text
local function setStatus(text: string)
	if statusLabel then
		statusLabel.Text = text
	end
end

-- Main preload function — loads all assets, then hides
function LoadingScreen.PreloadAll(onComplete: () -> ())
	if not gui then
		build()
	end

	setStatus("Preparing Ooo...")
	setProgress(0)

	-- Assets to preload (from src/assets/ — populated when user drops files there)
	-- For now, we preload what exists in ReplicatedStorage (models, images, sounds)
	-- and Studio's default assets (R15 rig, etc.)
	local toPreload: { Instance } = {}

	-- Add all UI ScreenGuis (they contain ImageLabels if user drops them in)
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	for _, child in ipairs(playerGui:GetDescendants()) do
		if child:IsA("ImageLabel") or child:IsA("ImageButton") then
			table.insert(toPreload, child)
		end
	end

	-- Add ReplicatedStorage children (models, sounds, etc. that user drops in)
	for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
		if child:IsA("Model") or child:IsA("Sound") or child:IsA("ImageLabel") then
			table.insert(toPreload, child)
		end
	end

	-- If nothing to preload, just finish
	if #toPreload == 0 then
		setProgress(1)
		setStatus("Ready!")
		task.wait(0.5)
		LoadingScreen.Hide()
		onComplete()
		return
	end

	-- Preload in batches to show progress
	local total = #toPreload
	local batchSize = math.max(1, math.floor(total / 20))
	local loaded = 0

	for i = 1, total, batchSize do
		local batch = {}
		for j = i, math.min(i + batchSize - 1, total) do
			table.insert(batch, toPreload[j])
		end

		setStatus(("Preloading %d of %d..."):format(loaded, total))
		ContentProvider:PreloadAsync(batch)
		loaded += #batch
		setProgress(loaded / total)
		task.wait(0.05)
	end

	setProgress(1)
	setStatus("Ready!")
	task.wait(0.3)
	LoadingScreen.Hide()
	onComplete()
end

function LoadingScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

function LoadingScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
end

return LoadingScreen
