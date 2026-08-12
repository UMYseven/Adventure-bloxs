--!strict
-- Quest log — list of active and completed quests with details.
-- Lives in StarterPlayerScripts.Client.UI.QuestLogScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local QuestLogScreen = {}

local gui
local questList

local function build()
	gui = UiUtil.makeScreenGui("QuestLog", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.6, 0, 0.8, 0),
		UDim2.new(0.2, 0, 0.1, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "QUEST LOG", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		QuestLogScreen.Hide()
	end)

	-- Two columns: active (left), completed (right)
	local activePanel = UiUtil.makeFrame("Active", UDim2.new(0.45, 0, 0.8, 0), UDim2.new(0.02, 0, 0.12, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("ActiveTitle", "ACTIVE", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(120, 200, 120), activePanel, Enum.Font.GothamBold)

	local completedPanel = UiUtil.makeFrame("Completed", UDim2.new(0.45, 0, 0.8, 0), UDim2.new(0.53, 0, 0.12, 0), Color3.fromRGB(20, 20, 30), panel)
	UiUtil.makeLabel("CompletedTitle", "COMPLETED", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(180, 180, 180), completedPanel, Enum.Font.GothamBold)

	questList = { active = activePanel, completed = completedPanel }

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

local function addQuestEntry(parent: Instance, quest: any)
	local entry = UiUtil.makeFrame("QuestEntry", UDim2.new(1, 0, 0.15, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(40, 40, 55), parent)
	UiUtil.makeLabel("Name", quest.name or "Quest", UDim2.new(1, 0, 0.4, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), entry, Enum.Font.GothamBold)
	local desc = UiUtil.makeLabel("Desc", quest.description or "", UDim2.new(1, 0, 0.6, 0), UDim2.new(0, 0, 0.4, 0), Color3.fromRGB(200, 200, 200), entry, Enum.Font.Gotham)
	desc.TextWrapped = true
	if quest.progress then
		UiUtil.makeLabel("Progress", quest.progress, UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.8, 0), Color3.fromRGB(120, 200, 120), entry, Enum.Font.GothamBold)
	end
end

function QuestLogScreen.SetQuests(active: { any }, completed: { any })
	if not gui then
		build()
	end
	-- Clear
	for _, child in ipairs(questList.active:GetChildren()) do
		if child:IsA("Frame") and child.Name ~= "ActiveTitle" then
			child:Destroy()
		end
	end
	for _, child in ipairs(questList.completed:GetChildren()) do
		if child:IsA("Frame") and child.Name ~= "CompletedTitle" then
			child:Destroy()
		end
	end
	-- Populate
	local activeLayout = Instance.new("UIListLayout")
	activeLayout.Padding = UDim.new(0, 5)
	activeLayout.Parent = questList.active
	local completedLayout = Instance.new("UIListLayout")
	completedLayout.Padding = UDim.new(0, 5)
	completedLayout.Parent = questList.completed

	for _, q in ipairs(active) do
		addQuestEntry(questList.active, q)
	end
	for _, q in ipairs(completed) do
		addQuestEntry(questList.completed, q)
	end
end

function QuestLogScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer("RequestQuests")
	end
end

function QuestLogScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return QuestLogScreen
