--!strict
-- Map / fast-travel screen — shows discovered shrines, click to fast-travel.
-- Lives in StarterPlayerScripts.Client.UI.MapScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local MapScreen = {}

local gui
local shrineButtons = {} :: { [string]: TextButton }

-- Placeholder shrine positions on the map (normalized 0-1)
local SHRINES = {
	{ id = "CK_Shrine", name = "Candy Kingdom", x = 0.5, y = 0.3, locked = false },
	{ id = "GL_Shrine", name = "Grasslands Camp", x = 0.5, y = 0.7, locked = false },
	{ id = "Hilltop", name = "Hilltop Shrine", x = 0.5, y = 0.85, locked = true },
	{ id = "WolfDen", name = "Wolf Den", x = 0.4, y = 0.9, locked = true },
}

local function build()
	gui = UiUtil.makeScreenGui("MapScreen", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.8, 0, 0.8, 0),
		UDim2.new(0.1, 0, 0.1, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "MAP OF OOO", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		MapScreen.Hide()
	end)

	-- Map area
	local mapArea = UiUtil.makeFrame("MapArea", UDim2.new(0.9, 0, 0.8, 0), UDim2.new(0.05, 0, 0.12, 0), Color3.fromRGB(60, 100, 60), panel)

	-- Shrine buttons
	for _, shrine in ipairs(SHRINES) do
		local color = shrine.locked and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(180, 180, 220)
		local btn = UiUtil.makeButton(
			shrine.id,
			shrine.name,
			UDim2.new(0.15, 0, 0.06, 0),
			UDim2.new(shrine.x - 0.075, 0, shrine.y - 0.03, 0),
			color,
			mapArea
		)
		if shrine.locked then
			btn.Text = "🔒 " .. shrine.name
		end
		btn.MouseButton1Click:Connect(function()
			if not shrine.locked then
				local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
				if c2s and c2s:IsA("RemoteEvent") then
					c2s:FireServer("FastTravel", { shrineId = shrine.id })
				end
				MapScreen.Hide()
			end
		end)
		shrineButtons[shrine.id] = btn
	end

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function MapScreen.UnlockShrine(shrineId: string)
	local btn = shrineButtons[shrineId]
	if btn then
		btn.BackgroundColor3 = Color3.fromRGB(180, 180, 220)
		btn.Text = btn.Text:gsub("🔒 ", "")
	end
end

function MapScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
end

function MapScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return MapScreen
