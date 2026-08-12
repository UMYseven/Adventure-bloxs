--!strict
-- Death / respawn screen — shows on death, with respawn options + death penalty summary.
-- Lives in StarterPlayerScripts.Client.UI.DeathScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local DeathScreen = {}

local gui
local goldLostLabel
local xpDebtLabel
local respawnBtn

local function build()
	gui = UiUtil.makeScreenGui("DeathScreen", 95)

	local overlay = UiUtil.makeOverlay(gui)
	overlay.BackgroundTransparency = 0.3

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.4, 0, 0.5, 0),
		UDim2.new(0.3, 0, 0.25, 0),
		Color3.fromRGB(40, 20, 30),
		overlay
	)

	UiUtil.makeLabel("Title", "YOU HAVE FALLEN", UDim2.new(1, 0, 0.15, 0), UDim2.new(0, 0, 0.05, 0), Color3.fromRGB(255, 80, 80), panel, Enum.Font.GothamBlack)

	UiUtil.makeLabel("Subtitle", "The Lich whispers...", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.25, 0), Color3.fromRGB(200, 200, 200), panel, Enum.Font.GothamMedium)

	goldLostLabel = UiUtil.makeLabel("GoldLost", "Gold lost: 0", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.4, 0), Color3.fromRGB(240, 200, 80), panel, Enum.Font.GothamBold)
	xpDebtLabel = UiUtil.makeLabel("XPDebt", "XP debt: 0", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.55, 0), Color3.fromRGB(200, 120, 200), panel, Enum.Font.GothamBold)

	respawnBtn = UiUtil.makeButton("Respawn", "RESPAWN AT LAST BMO", UDim2.new(0.6, 0, 0.15, 0), UDim2.new(0.2, 0, 0.75, 0), Color3.fromRGB(80, 200, 120), panel)
	respawnBtn.MouseButton1Click:Connect(function()
		local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
		if c2s and c2s:IsA("RemoteEvent") then
			c2s:FireServer("Respawn")
		end
		DeathScreen.Hide()
	end)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function DeathScreen.Show(payload: any)
	if not gui then
		build()
	end
	if payload.goldLost then
		goldLostLabel.Text = ("Gold lost: %d"):format(payload.goldLost)
	end
	if payload.xpDebt then
		xpDebtLabel.Text = ("XP debt: %d"):format(payload.xpDebt)
	end
	gui.Enabled = true
end

function DeathScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return DeathScreen
