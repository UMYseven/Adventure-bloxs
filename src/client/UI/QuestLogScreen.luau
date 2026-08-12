--!strict
-- Quest log — list of active and completed quests with details.
-- Lives in StarterPlayerScripts.Client.UI.QuestLogScreen
--
-- Figma style: framed panel, gold title, ACTIVE / COMPLETED columns with
-- scrollable quest cards (gold name, description, progress bar).
-- Supports variants A/B/C. Sample quests show until the server sends real ones.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local QuestLogScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local questList
local hasServerQuests = false

local SAMPLE_ACTIVE = {
	{ name = "Sweet Beginnings", description = "Talk to Princess Bubblegum in the Candy Castle.", progress = "0 / 1" },
	{ name = "Tart Toter Trouble", description = "Defeat 3 Candy Bandits near the market.", progress = "1 / 3" },
	{ name = "The Old Road", description = "Follow the old road to the Grasslands Camp.", progress = "" },
}

local SAMPLE_COMPLETED = {
	{ name = "A New Timeline", description = "Complete character creation in Prismo's Time Room.", progress = "Done" },
}

local function makeSection(parent: Instance, name: string, title: string, titleColor: Color3, xPos: number): ScrollingFrame
	local sectionPanel = UiUtil.makeFrame(
		name .. "Panel",
		UDim2.new(0.45, 0, 0.78, 0),
		UDim2.new(xPos, 0, 0.13, 0),
		style.PanelAlt,
		parent
	)
	UiUtil.applyPanelStyle(sectionPanel, style)
	sectionPanel.BackgroundColor3 = style.PanelAlt

	UiUtil.makeLabel(
		"SectionTitle",
		title,
		UDim2.new(1, 0, 0.07, 0),
		UDim2.new(0, 0, 0.01, 0),
		titleColor,
		sectionPanel,
		Theme.Fonts.Header
	)

	local scroller = Instance.new("ScrollingFrame")
	scroller.Name = name
	scroller.Size = UDim2.new(0.94, 0, 0.88, 0)
	scroller.Position = UDim2.new(0.03, 0, 0.1, 0)
	scroller.BackgroundTransparency = 1
	scroller.BorderSizePixel = 0
	scroller.ScrollBarThickness = 6
	scroller.ScrollBarImageColor3 = style.Accent
	scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroller.Parent = sectionPanel

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0.02, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scroller

	return scroller
end

local function build()
	gui = UiUtil.makeScreenGui("QuestLog", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.62, 0, 0.82, 0),
		UDim2.new(0.19, 0, 0.09, 0),
		style.Panel,
		overlay
	)
	UiUtil.applyPanelStyle(panel, style)

	UiUtil.makeTitleBar(panel, "QUEST LOG", style, function()
		QuestLogScreen.Hide()
	end)

	questList = {
		active = makeSection(panel, "Active", "ACTIVE", Theme.Colors.AccentGold, 0.035),
		completed = makeSection(panel, "Completed", "COMPLETED", Theme.Colors.TextMuted, 0.525),
	}

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

local function addQuestEntry(parent: Instance, quest: any, layoutOrder: number)
	local entry = UiUtil.makeFrame(
		"QuestEntry",
		UDim2.new(1, 0, 0, 76),
		UDim2.new(0, 0, 0, 0),
		style.Slot,
		parent
	)
	entry.LayoutOrder = layoutOrder

	local corner = entry:FindFirstChildOfClass("UICorner")
	if corner then
		corner.CornerRadius = UDim.new(0.1, 0)
	end

	local stroke = Instance.new("UIStroke")
	stroke.Color = style.Border
	stroke.Thickness = math.max(style.BorderThickness, 1)
	stroke.Transparency = math.max(style.BorderTransparency, 0.6)
	stroke.Parent = entry

	local nameLabel = UiUtil.makeLabel(
		"Name",
		quest.name or "Quest",
		UDim2.new(0.92, 0, 0.32, 0),
		UDim2.new(0.04, 0, 0.05, 0),
		style.TitleColor,
		entry,
		Theme.Fonts.Header
	)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local desc = UiUtil.makeLabel(
		"Desc",
		quest.description or "",
		UDim2.new(0.92, 0, 0.4, 0),
		UDim2.new(0.04, 0, 0.36, 0),
		Theme.Colors.TextSecondary,
		entry,
		Theme.Fonts.BodyLight
	)
	desc.TextWrapped = true
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top

	if quest.progress and quest.progress ~= "" then
		local progress = UiUtil.makeLabel(
			"Progress",
			quest.progress,
			UDim2.new(0.92, 0, 0.24, 0),
			UDim2.new(0.04, 0, 0.74, 0),
			Theme.Colors.AccentGold,
			entry,
			Theme.Fonts.Header
		)
		progress.TextXAlignment = Enum.TextXAlignment.Left
	end
end

local function populate(active: { any }, completed: { any })
	for _, child in ipairs(questList.active:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	for _, child in ipairs(questList.completed:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for i, q in ipairs(active) do
		addQuestEntry(questList.active, q, i)
	end
	for i, q in ipairs(completed) do
		addQuestEntry(questList.completed, q, i)
	end
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function QuestLogScreen.Init(variant: string?)
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
	populate(SAMPLE_ACTIVE, SAMPLE_COMPLETED)
end

function QuestLogScreen.SetQuests(active: { any }, completed: { any })
	hasServerQuests = true
	if not gui then
		QuestLogScreen.Init()
	end
	populate(active, completed)
end

function QuestLogScreen.Show()
	if not gui then
		QuestLogScreen.Init()
	end
	gui.Enabled = true
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer("RequestQuests")
	end
	-- Sample quests stay unless the server has already sent real ones
	if not hasServerQuests then
		populate(SAMPLE_ACTIVE, SAMPLE_COMPLETED)
	end
end

function QuestLogScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return QuestLogScreen
