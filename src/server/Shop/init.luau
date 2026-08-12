--!strict
-- Shop system — placeholder shop items for beta.
-- Lives in ServerScriptService.Server.Core.Shop
--
-- Real item catalog + prices locked in post-beta. Beta shows placeholder items
-- so the Shop screen isn't empty.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"))

local Shop = {}

-- Placeholder shop items (real catalog in Season 1)
local SHOP_ITEMS = {
	{ id = "sword_basic", name = "Training Sword", price = 50, tier = "Common", icon = "⚔️" },
	{ id = "apple_pie", name = "Apple Pie", price = 10, tier = "Common", icon = "🥧" },
	{ id = "energy_drink", name = "Energy Drink", price = 25, tier = "Common", icon = "🥤" },
	{ id = "cosmetic_hat", name = "Candy Crown Hat", price = 200, tier = "Rare", icon = "👑" },
	{ id = "cosmetic_aura", name = "Sparkle Aura", price = 350, tier = "Epic", icon = "✨" },
	{ id = "reroll_token", name = "Reroll Token", price = 500, tier = "Legendary", icon = "🎲" },
}

function Shop.GetItems()
	return SHOP_ITEMS
end

function Shop.BuyItem(player: Player, itemId: string)
	local data = DataStore.Get(player.UserId)
	if not data then
		return false, "No data"
	end

	for _, item in ipairs(SHOP_ITEMS) do
		if item.id == itemId then
			if data.gold < item.price then
				return false, "Not enough gold"
			end
			data.gold -= item.price
			-- Add to inventory
			local found = false
			for _, inv in ipairs(data.inventory) do
				if inv.id == itemId then
					inv.quantity += 1
					found = true
					break
				end
			end
			if not found then
				table.insert(data.inventory, { id = itemId, quantity = 1 })
			end
			DataStore.Set(player.UserId, data)
			return true, "Purchased " .. item.name
		end
	end
	return false, "Item not found"
end

function Shop.Init()
	-- Handle shop requests from client
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(function(player: Player, action: string, payload: any)
			if action == "RequestShop" then
				local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
				if s2c and s2c:IsA("RemoteEvent") then
					s2c:FireClient(player, "ShopItems", Shop.GetItems())
					local data = DataStore.Get(player.UserId)
					if data then
						s2c:FireClient(player, "ShopGold", data.gold)
					end
				end
			elseif action == "BuyItem" and payload and payload.itemId then
				local ok, msg = Shop.BuyItem(player, payload.itemId)
				local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
				if s2c and s2c:IsA("RemoteEvent") then
					s2c:FireClient(player, "ShopPurchaseResult", { success = ok, message = msg })
					if ok then
						s2c:FireClient(player, "ShopGold", DataStore.Get(player.UserId).gold)
					end
				end
			end
		end)
	end
	print("[Shop] initialized")
end

return Shop
