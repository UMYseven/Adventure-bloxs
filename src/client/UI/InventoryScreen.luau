--!strict
-- Inventory screen — grid of item slots with item icon, name, quantity, rarity.
-- Lives in StarterPlayerScripts.Client.UI.InventoryScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local InventoryScreen = {}

local gui
local grid

local TIER_COLORS = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(80, 200, 80),
	Rare = Color3.fromRGB(80, 140, 240),
	Epic = Color3.fromRGB(180, 80, 240),
	Legendary = Color3.fromRGB(240, 180, 60),
	Mythic = Color3.fromRGB(240, 60, 60),
}

local function build()
	gui = UiUtil.makeScreenGui("Inventory", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.7, 0, 0.8, 0),
		UDim2.new(0.15, 0, 0.1, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "INVENTORY", UDim2.new(1, 0, 0.08, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		InventoryScreen.Hide()
	end)

	-- Grid container
	local gridContainer = UiUtil.makeFrame(
		"GridContainer",
		UDim2.new(0.9, 0, 0.8, 0),
		UDim2.new(0.05, 0, 0.12, 0),
		Color3.fromRGB(20, 20, 30),
		panel
	)

	-- UIGridLayout for the slots
	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(0.15, 0, 0.18, 0)
	layout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = gridContainer

	grid = gridContainer

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Populate the grid with items (called from server inventory sync)
function InventoryScreen.SetItems(items: { any })
	if not gui then
		build()
	end

	-- Clear existing
	for _, child in ipairs(grid:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for i, item in ipairs(items) do
		local tier = item.tier or "Common"
		local color = TIER_COLORS[tier] or Color3.fromRGB(180, 180, 180)
		local slot = UiUtil.makeFrame("Slot" .. i, UDim2.fromScale(1, 1), UDim2.new(0, 0, 0, 0), color, grid)
		UiUtil.makeLabel("Icon", item.icon or "?", UDim2.new(1, 0, 0.7, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), slot, Enum.Font.GothamBold)
		UiUtil.makeLabel("Name", item.name or "Item", UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.7, 0), Color3.fromRGB(255, 255, 255), slot, Enum.Font.GothamMedium)
		local qty = UiUtil.makeLabel("Qty", "x" .. tostring(item.quantity or 1), UDim2.new(0.4, 0, 0.2, 0), UDim2.new(0.55, 0, 0.78, 0), Color3.fromRGB(255, 255, 255), slot, Enum.Font.GothamBold)
		qty.TextXAlignment = Enum.TextXAlignment.Right
	end
end

function InventoryScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
	-- Request inventory from server
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer("RequestInventory")
	end
end

function InventoryScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return InventoryScreen
