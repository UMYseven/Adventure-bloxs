--!strict
-- Shop screen — buy/sell items with gold. Cosmetic + reroll tokens + consumables.
-- Lives in StarterPlayerScripts.Client.UI.ShopScreen

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local ShopScreen = {}

local gui
local itemsContainer
local goldLabel

local TIER_COLORS = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(80, 200, 80),
	Rare = Color3.fromRGB(80, 140, 240),
	Epic = Color3.fromRGB(180, 80, 240),
	Legendary = Color3.fromRGB(240, 180, 60),
}

local function build()
	gui = UiUtil.makeScreenGui("Shop", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.7, 0, 0.8, 0),
		UDim2.new(0.15, 0, 0.1, 0),
		Color3.fromRGB(30, 30, 45),
		overlay
	)

	UiUtil.makeLabel("Title", "SHOP", UDim2.new(0.5, 0, 0.08, 0), UDim2.new(0, 0, 0.02, 0), Color3.fromRGB(255, 255, 255), panel, Enum.Font.GothamBlack)

	goldLabel = UiUtil.makeLabel("Gold", "Gold: 0", UDim2.new(0.3, 0, 0.08, 0), UDim2.new(0.65, 0, 0.02, 0), Color3.fromRGB(240, 200, 80), panel, Enum.Font.GothamBold)

	local closeBtn = UiUtil.makeButton("Close", "X", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.93, 0, 0.02, 0), Color3.fromRGB(200, 80, 80), panel)
	closeBtn.MouseButton1Click:Connect(function()
		ShopScreen.Hide()
	end)

	itemsContainer = UiUtil.makeFrame("Items", UDim2.new(0.9, 0, 0.8, 0), UDim2.new(0.05, 0, 0.12, 0), Color3.fromRGB(20, 20, 30), panel)

	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(0.22, 0, 0.25, 0)
	layout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
	layout.Parent = itemsContainer

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

function ShopScreen.SetGold(gold: number)
	if goldLabel then
		goldLabel.Text = ("Gold: %d"):format(gold)
	end
end

function ShopScreen.SetItems(items: { any })
	if not gui then
		build()
	end
	for _, child in ipairs(itemsContainer:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	for i, item in ipairs(items) do
		local tier = item.tier or "Common"
		local color = TIER_COLORS[tier] or Color3.fromRGB(180, 180, 180)
		local slot = UiUtil.makeFrame("Item" .. i, UDim2.fromScale(1, 1), UDim2.new(0, 0, 0, 0), color, itemsContainer)
		UiUtil.makeLabel("Icon", item.icon or "?", UDim2.new(1, 0, 0.4, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), slot, Enum.Font.GothamBold)
		UiUtil.makeLabel("Name", item.name or "Item", UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.4, 0), Color3.fromRGB(255, 255, 255), slot, Enum.Font.GothamMedium)
		local price = UiUtil.makeLabel("Price", tostring(item.price or 0) .. "g", UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.65, 0), Color3.fromRGB(240, 200, 80), slot, Enum.Font.GothamBold)
		price.TextXAlignment = Enum.TextXAlignment.Center
		local buyBtn = UiUtil.makeButton("Buy", "BUY", UDim2.new(0.8, 0, 0.15, 0), UDim2.new(0.1, 0, 0.82, 0), Color3.fromRGB(80, 200, 120), slot)
		buyBtn.MouseButton1Click:Connect(function()
			local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
			if c2s and c2s:IsA("RemoteEvent") then
				c2s:FireServer("BuyItem", { itemId = item.id, price = item.price })
			end
		end)
	end
end

function ShopScreen.Show()
	if not gui then
		build()
	end
	gui.Enabled = true
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer("RequestShop")
	end
end

function ShopScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return ShopScreen
