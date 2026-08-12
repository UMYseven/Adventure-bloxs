--!strict
-- Pause menu — Esc opens a pause overlay with Resume, Inventory, Quest Log,
-- Settings, Map, Return to Title (beta: disabled), Leave Game.
-- Lives in StarterPlayerScripts.Client.UI.PauseMenu

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local PauseMenu = {}

local gui
local visible = false

local function build()
	gui = UiUtil.makeScreenGui("PauseMenu", 80)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.3, 0, 0.7, 0),
		UDim2.new(0.35,  0, 0.15, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "PAUSED", UDim2.new(1, 0, 0.12, 0), UDim2.new(0, 0, 0.05, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local buttons = {
		{ "Resume", "RESUME", Color3.fromRGB(80, 200, 120) },
		{ "Inventory", "INVENTORY", Color3.fromRGB(80, 120, 200) },
		{ "QuestLog", "QUEST LOG", Color3.fromRGB(200, 180, 80) },
		{ "Settings", "SETTINGS", Color3.fromRGB(120, 120, 140) },
		{ "Map", "MAP", Color3.fromRGB(140, 100, 200) },
		{ "Leave", "LEAVE GAME", Color3.fromRGB(200, 80, 80) },
	}

	for i, b in ipairs(buttons) do
		local btn = UiUtil.makeButton(b[1], b[2], UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0.1, 0, 0.2 + (i - 1) * 0.12, 0), b[3], panel)
		btn.MouseButton1Click:Connect(function()
			if b[1] == "Resume" then
				PauseMenu.Hide()
			else
				-- Fire a BindableEvent so other UI systems can open
				local openEvent = ReplicatedStorage:FindFirstChild("OpenUIScreen")
				if openEvent and openEvent:IsA("BindableEvent") then
					openEvent:Fire(b[1])
				end
				PauseMenu.Hide()
			end
		end)
	end

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function PauseMenu.Show()
	if not gui then
		build()
	end
	visible = true
	gui.Enabled = true
end

function PauseMenu.Hide()
	visible = false
	if gui then
		gui.Enabled = false
	end
end

function PauseMenu.Toggle()
	if visible then
		PauseMenu.Hide()
	else
		PauseMenu.Show()
	end
end

function PauseMenu.Init()
	-- Esc toggles pause
	UserInputService.InputBegan:Connect(function(i: InputObject, processed: boolean)
		if not processed and i.KeyCode == Enum.KeyCode.Escape then
			PauseMenu.Toggle()
		end
	end)
end

return PauseMenu
