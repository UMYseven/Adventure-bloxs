--!strict
-- Duel request screen — incoming duel request with Accept/Decline.
-- Lives in StarterPlayerScripts.Client.UI.DuelScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local DuelScreen = {}

local gui
local challengerLabel
local acceptBtn
local declineBtn
local pendingChallenger

local function build()
	gui = UiUtil.makeScreenGui("DuelRequest", 90)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.4, 0, 0.3, 0),
		UDim2.new(0.3, 0, 0.35, 0),
		Color3.fromRGB(40, 20, 20),
		overlay
	)

	UiUtil.makeLabel("Title", "DUEL REQUEST", UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.05, 0), Color3.fromRGB(255, 100, 100), panel, Enum.Font.GothamBlack)

	challengerLabel = UiUtil.makeLabel("Challenger", "", UDim2.new(1, 0, 0.3, 0), UDim2.new(0, 0, 0.3, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBold)

	acceptBtn = UiUtil.makeButton("Accept", "ACCEPT", UDim2.new(0.4, 0, 0.2, 0), UDim2.new(0.05, 0, 0.7, 0), Color3.fromRGB(80, 200, 120), panel)
	declineBtn = UiUtil.makeButton("Decline", "DECLINE", UDim2.new(0.4, 0, 0.2, 0), UDim2.new(0.55, 0, 0.7, 0), Color3.fromRGB(200, 80, 80), panel)

	acceptBtn.MouseButton1Click:Connect(function()
		if pendingChallenger then
			local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
			if c2s and c2s:IsA("RemoteEvent") then
				c2s:FireServer("DuelAccept", { challenger = pendingChallenger })
			end
		end
		DuelScreen.Hide()
	end)

	declineBtn.MouseButton1Click:Connect(function()
		if pendingChallenger then
			local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
			if c2s and c2s:IsA("RemoteEvent") then
				c2s:FireServer("DuelDecline", { challenger = pendingChallenger })
			end
		end
		DuelScreen.Hide()
	end)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function DuelScreen.Show(challengerName: string)
	if not gui then
		build()
	end
	pendingChallenger = challengerName
	challengerLabel.Text = challengerName .. " challenges you!"
	gui.Enabled = true
end

function DuelScreen.Hide()
	if gui then
		gui.Enabled = false
	end
	pendingChallenger = nil
end

return DuelScreen
