--!strict
-- NPC dialog screen — portrait, name plate, text body + response choices.
-- Lives in StarterPlayerScripts.Client.UI.DialogScreen
--
-- Figma style: bottom dialogue box, circular portrait on the left with a gold
-- name plate, body text, choice buttons stacked on the right.
-- Supports variants A/B/C.

local Players = game:GetService("Players")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local DialogScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local portrait
local portraitLetter
local nameLabel
local textLabel
local choicesContainer
local onCompleteCallback

local function build()
	gui = UiUtil.makeScreenGui("Dialog", 60)

	-- Bottom panel (dialogue box style)
	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.62, 0, 0.26, 0),
		UDim2.new(0.19, 0, 0.7, 0),
		style.Panel,
		gui
	)
	UiUtil.applyPanelStyle(panel, style)

	-- Portrait (left, circular with gold ring)
	portrait = UiUtil.makeFrame("Portrait", UDim2.new(0.14, 0, 0.52, 0), UDim2.new(0.04, 0, 0.24, 0), style.Slot, panel)
	local portraitCorner = portrait:FindFirstChildOfClass("UICorner")
	if portraitCorner then
		portraitCorner.CornerRadius = UDim.new(0.5, 0)
	end
	local portraitStroke = Instance.new("UIStroke")
	portraitStroke.Color = style.Accent
	portraitStroke.Thickness = math.max(style.BorderThickness, 1)
	portraitStroke.Transparency = style.BorderTransparency
	portraitStroke.Parent = portrait

	portraitLetter = UiUtil.makeLabel(
		"Letter",
		"?",
		UDim2.fromScale(1, 1),
		UDim2.new(0, 0, 0, 0),
		style.TitleColor,
		portrait,
		Theme.Fonts.Title
	)

	-- Name plate (gold bar overlapping the portrait top)
	local namePlate = UiUtil.makeFrame(
		"NamePlate",
		UDim2.new(0.24, 0, 0.16, 0),
		UDim2.new(0.02, 0, 0.06, 0),
		Theme.Colors.AccentGold,
		panel
	)
	local plateCorner = namePlate:FindFirstChildOfClass("UICorner")
	if plateCorner then
		plateCorner.CornerRadius = UDim.new(0.3, 0)
	end

	nameLabel = UiUtil.makeLabel(
		"Name",
		"",
		UDim2.new(0.94, 0, 0.9, 0),
		UDim2.new(0.03, 0, 0.05, 0),
		Theme.Colors.PanelDark,
		namePlate,
		Theme.Fonts.Title
	)

	-- Text (main body)
	textLabel = UiUtil.makeLabel(
		"Text",
		"",
		UDim2.new(0.66, 0, 0.5, 0),
		UDim2.new(0.22, 0, 0.14, 0),
		Theme.Colors.TextPrimary,
		panel,
		Theme.Fonts.Body
	)
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top

	-- Choices container (right side of panel)
	choicesContainer = UiUtil.makeFrame("Choices", UDim2.new(0.34, 0, 0.62, 0), UDim2.new(0.62, 0, 0.34, 0), style.Panel, panel)
	choicesContainer.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0.06, 0)
	layout.Parent = choicesContainer

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function DialogScreen.Init(variant: string?)
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

-- Show a dialog. dialog = { npcName, portraitColor, text, choices = { {text, action} }, mumbleId }
function DialogScreen.Show(dialog: any, onComplete: (() -> ())?)
	if not gui then
		DialogScreen.Init()
	end
	onCompleteCallback = onComplete

	portrait.BackgroundColor3 = dialog.portraitColor or style.Slot
	portraitLetter.Text = string.sub(dialog.npcName or "?", 1, 1)
	nameLabel.Text = dialog.npcName or "NPC"
	textLabel.Text = dialog.text or ""

	-- Clear choices
	for _, child in ipairs(choicesContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	-- Add choices
	for i, choice in ipairs(dialog.choices or {}) do
		local btn = UiUtil.makeButton(
			"Choice" .. i,
			choice.text,
			UDim2.new(1, 0, 0.3, 0),
			UDim2.new(0, 0, 0, 0),
			style.ButtonColor,
			choicesContainer
		)
		btn.Font = Theme.Fonts.Body
		btn.TextXAlignment = Enum.TextXAlignment.Left

		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = style.Border
		btnStroke.Thickness = math.max(style.BorderThickness, 1)
		btnStroke.Transparency = if style.BorderThickness > 0 then style.BorderTransparency else 0.7
		btnStroke.Parent = btn

		btn.MouseButton1Click:Connect(function()
			DialogScreen.Hide()
			if choice.action then
				choice.action()
			end
			if onCompleteCallback then
				onCompleteCallback()
			end
		end)
	end

	-- Play mumble voice (placeholder: just print)
	if dialog.mumbleId then
		-- Real: play audio asset. Placeholder: log it.
		print(("[Dialog] mumble: %s"):format(dialog.mumbleId))
	end

	gui.Enabled = true
end

function DialogScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return DialogScreen
