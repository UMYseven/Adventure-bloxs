--!strict
-- Loading screen — shown while preloading all assets, before RNG character creation.
-- Lives in StarterPlayerScripts.Client.UI.LoadingScreen
--
-- Flow: Player joins → LoadingScreen shows → ContentProvider preloads all assets →
--   LoadingScreen fades → RNGScreen shows (if firstSpawn) → player spawns in Candy Kingdom.
--
-- Figma style: full-screen dark background, gold title, gold progress bar.
-- Supports variants A (minimal), B (medium frame), C (ornate frame + gems).
-- Placeholder visuals: colored frames + text. Real art swapped in later.

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local LoadingScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local progressFill
local progressLabel
local statusLabel

local function build()
	gui = UiUtil.makeScreenGui("LoadingScreen", 200) -- above everything else

	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Theme.Colors.Background
	bg.BorderSizePixel = 0
	bg.Parent = gui

	-- Center card holding logo + progress (framed per variant B/C)
	local card = UiUtil.makeFrame(
		"Card",
		UDim2.new(0.6, 0, 0.5, 0),
		UDim2.new(0.2, 0, 0.22, 0),
		style.Panel,
		bg
	)
	UiUtil.applyPanelStyle(card, style)
	-- Variant A has no border/decorations: keep the card invisible (bare text)
	if style.BorderThickness == 0 and not style.Decorations then
		card.BackgroundTransparency = 1
	end

	-- Logo placeholder
	UiUtil.makeLabel(
		"Logo",
		"ADVENTURE TIME: OOO",
		UDim2.new(0.9, 0, 0.3, 0),
		UDim2.new(0.05, 0, 0.06, 0),
		style.TitleColor,
		card,
		Theme.Fonts.Title
	)

	-- Subtitle
	UiUtil.makeLabel(
		"Subtitle",
		"The timeline has fractured...",
		UDim2.new(0.9, 0, 0.14, 0),
		UDim2.new(0.05, 0, 0.36, 0),
		Theme.Colors.TextSecondary,
		card,
		Theme.Fonts.Body
	)

	-- Progress bar background
	local progressBg = UiUtil.makeFrame(
		"ProgressBg",
		UDim2.new(0.8, 0, 0.1, 0),
		UDim2.new(0.1, 0, 0.56, 0),
		Theme.Colors.PanelDark,
		card
	)
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0.5, 0)
	barCorner.Parent = progressBg
	if style.BorderThickness > 0 then
		local barStroke = Instance.new("UIStroke")
		barStroke.Color = style.Border
		barStroke.Thickness = 1
		barStroke.Transparency = style.BorderTransparency
		barStroke.Parent = progressBg
	end

	-- Progress bar fill
	progressFill = Instance.new("Frame")
	progressFill.Name = "Fill"
	progressFill.Size = UDim2.fromScale(0, 1)
	progressFill.BackgroundColor3 = Theme.Colors.AccentGold
	progressFill.BorderSizePixel = 0
	progressFill.Parent = progressBg

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = progressFill

	-- Progress label
	progressLabel = UiUtil.makeLabel(
		"Progress",
		"Loading... 0%",
		UDim2.new(0.8, 0, 0.08, 0),
		UDim2.new(0.1, 0, 0.68, 0),
		Theme.Colors.TextPrimary,
		card,
		Theme.Fonts.Header
	)

	-- Status label (what's currently loading)
	statusLabel = UiUtil.makeLabel(
		"Status",
		"Initializing...",
		UDim2.new(0.8, 0, 0.08, 0),
		UDim2.new(0.1, 0, 0.78, 0),
		Theme.Colors.TextMuted,
		card,
		Theme.Fonts.Body
	)

	-- Ornate corner gems on the card (variant C)
	if style.Decorations then
		for _, pos in ipairs({ { 0.02, 0.06 }, { 0.98, 0.06 }, { 0.02, 0.94 }, { 0.98, 0.94 } }) do
			local gem = Instance.new("Frame")
			gem.Name = "Gem"
			gem.Size = UDim2.fromOffset(12, 12)
			gem.AnchorPoint = Vector2.new(0.5, 0.5)
			gem.Position = UDim2.fromScale(pos[1], pos[2])
			gem.Rotation = 45
			gem.BackgroundColor3 = style.Accent
			gem.BorderSizePixel = 0
			gem.Parent = card
		end
	end

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

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function LoadingScreen.Init(variant: string?)
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
	gui.Enabled = false
end

-- Main preload function — loads all assets, then hides
function LoadingScreen.PreloadAll(onComplete: () -> ())
	if not gui then
		LoadingScreen.Init()
	end
	gui.Enabled = true

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
		LoadingScreen.Init()
	end
	gui.Enabled = true
end

return LoadingScreen
