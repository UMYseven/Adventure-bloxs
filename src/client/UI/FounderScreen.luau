--!strict
-- Founder's Pack redemption screen — enter code, claim exclusive rewards.
-- Lives in StarterPlayerScripts.Client.UI.FounderScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local FounderScreen = {}

local gui
local codeBox
local claimBtn
local statusLabel

local function build()
	gui = UiUtil.makeScreenGui("FounderScreen", 75)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.4, 0, 0.6, 0),
		UDim2.new(0.3, 0, 0.2, 0),
		Color3.fromRGB(30, 30, 50),
		overlay
	)

	UiUtil.makeLabel("Title", "FOUNDER'S PACK", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.05, 0), Color3.fromRGB(240, 200, 80), panel, Enum.Font.GothamBlack)

	UiUtil.makeLabel("Subtitle", "Enter your $5 Founder's code to claim:", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.2, 0), Color3.fromRGB(200, 200, 200), panel, Enum.Font.Gotham)

	-- Code input box
	codeBox = Instance.new("TextBox")
	codeBox.Name = "CodeInput"
	codeBox.Size = UDim2.new(0.8, 0, 0.1, 0)
	codeBox.Position = UDim2.new(0.1, 0, 0.32, 0)
	codeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	codeBox.Font = Enum.Font.GothamMedium
	codeBox.TextScaled = true
	codeBox.PlaceholderText = "XXXX-XXXX-XXXX"
	codeBox.ClearTextOnFocus = true
	codeBox.Parent = panel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = codeBox

	-- Claim button
	claimBtn = UiUtil.makeButton("Claim", "CLAIM", UDim2.new(0.4, 0, 0.12, 0), UDim2.new(0.3, 0, 0.5, 0), Color3.fromRGB(80, 200, 120), panel)
	claimBtn.MouseButton1Click:Connect(function()
		local code = codeBox.Text
		if code and #code > 0 then
			local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
			if c2s and c2s:IsA("RemoteEvent") then
				c2s:FireServer("RedeemFounderCode", { code = code })
			end
			statusLabel.Text = "Validating..."
			statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end)

	-- Status label
	statusLabel = UiUtil.makeLabel("Status", "", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.65, 0), Color3.fromRGB(200, 200, 200), panel, Enum.Font.Gotham)

	-- Close button
	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		FounderScreen.Hide()
	end)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function FounderScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
end

function FounderScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

function FounderScreen.SetStatus(text: string, success: boolean)
	if statusLabel then
		statusLabel.Text = text
		statusLabel.TextColor3 = success and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(240, 100, 100)
	end
end

return FounderScreen
