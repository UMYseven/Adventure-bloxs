--!strict
-- Lich omen finale screen — special weekend event UI, dark + ominous.
-- Lives in StarterPlayerScripts.Client.UI.LichFinaleScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local LichFinaleScreen = {}

local gui
local countdownLabel
local enterBtn

local function build()
	gui = UiUtil.makeScreenGui("LichFinale", 100)

	-- Full-screen dark overlay
	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
	overlay.BackgroundTransparency = 0.2
	overlay.BorderSizePixel = 0
	overlay.Parent = gui

	-- Pulsing red vignette (placeholder)
	local vignette = Instance.new("Frame")
	vignette.Name = "Vignette"
	vignette.Size = UDim2.fromScale(1, 1)
	vignette.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	vignette.BackgroundTransparency = 0.7
	vignette.BorderSizePixel = 0
	vignette.Parent = overlay

	-- Pulse the vignette
	task.spawn(function()
		while gui and gui.Enabled do
			TweenService:Create(vignette, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.5 }):Play()
			task.wait(1.5)
			TweenService:Create(vignette, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.85 }):Play()
			task.wait(1.5)
		end
	end)

	-- Warning text (top)
	UiUtil.makeLabel("Warning", "THE LICH HAS AWAKENED", UDim2.new(1, 0, 0.15, 0), UDim2.new(0, 0, 0.1, 0), Color3.fromRGB(255, 60, 60), overlay, Enum.Font.GothamBlack)

	-- Subtitle
	UiUtil.makeLabel("Subtitle", "An omen darkens the Candy Kingdom...", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.3, 0), Color3.fromRGB(200, 180, 200), overlay, Enum.Font.GothamMedium)

	-- Countdown (center)
	countdownLabel = UiUtil.makeLabel("Countdown", "Event begins in: --:--:--", UDim2.new(0.6, 0, 0.1, 0), UDim2.new(0.2, 0, 0.45, 0), Color3.fromRGB(255, 220, 100), overlay, Enum.Font.GothamBold)

	-- Enter button
	enterBtn = UiUtil.makeButton("Enter", "ENTER THE OMEN", UDim2.new(0.3, 0, 0.1, 0), UDim2.new(0.35, 0, 0.7, 0), Color3.fromRGB(120, 40, 40), overlay)
	enterBtn.MouseButton1Click:Connect(function()
		local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
		if c2s and c2s:IsA("RemoteEvent") then
			c2s:FireServer("EnterLichOmen")
		end
		LichFinaleScreen.Hide()
	end)

	-- Close button (opt out)
	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(80, 80, 80), overlay)
	closeBtn.MouseButton1Click:Connect(function()
		LichFinaleScreen.Hide()
	end)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function LichFinaleScreen.Show(countdownText: string?)
	if not gui then
		build()
	end
	if countdownText and countdownLabel then
		countdownLabel.Text = countdownText
	end
	gui.Enabled = true
end

function LichFinaleScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return LichFinaleScreen
