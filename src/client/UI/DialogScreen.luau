--!strict
-- NPC dialog screen — text + mumble voice + response choices.
-- Lives in StarterPlayerScripts.Client.UI.DialogScreen

local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local DialogScreen = {}

local gui
local portrait
local nameLabel
local textLabel
local choicesContainer
local onCompleteCallback

local function build()
	gui = UiUtil.makeScreenGui("Dialog", 60)

	-- Bottom panel (dialogue box style)
	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.6, 0, 0.25, 0),
		UDim2.new(0.2, 0, 0.7, 0),
		Color3.fromRGB(20, 20, 35),
		gui
	)

	-- Portrait (left)
	portrait = UiUtil.makeFrame("Portrait", UDim2.new(0.2, 0, 0.8, 0), UDim2.new(0.02, 0, 0.1, 0), Color3.fromRGB(80, 80, 120), panel)

	-- Name (top of text area)
	nameLabel = UiUtil.makeLabel("Name", "", UDim2.new(0.7, 0, 0.15, 0), UDim2.new(0.25, 0, 0.05, 0), Color3.fromRGB(255, 220, 100), panel, Enum.Font.GothamBlack)

	-- Text (main body)
	textLabel = UiUtil.makeLabel("Text", "", UDim2.new(0.7, 0, 0.5, 0), UDim2.new(0.25, 0, 0.25, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamMedium)
	textLabel.TextWrapped = true
	textLabel.TextYAlignment = Enum.TextYAlignment.Top

	-- Choices container (bottom of panel)
	choicesContainer = UiUtil.makeFrame("Choices", UDim2.new(0.7, 0, 0.2, 0), UDim2.new(0.25, 0, 0.78, 0), Color3.fromRGB(20, 20, 35), panel)
	choicesContainer.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = choicesContainer

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Show a dialog. dialog = { npcName, portraitColor, text, choices = { {text, action} }, mumbleId }
function DialogScreen.Show(dialog: any, onComplete: (() -> ())?)
	if not gui then
		build()
	end
	onCompleteCallback = onComplete

	portrait.BackgroundColor3 = dialog.portraitColor or Color3.fromRGB(80, 80, 120)
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
		local btn = UiUtil.makeButton("Choice" .. i, choice.text, UDim2.new(1, 0, 0.4, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(60, 80, 120), choicesContainer)
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
