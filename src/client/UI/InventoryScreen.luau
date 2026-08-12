--!strict
-- Inventory screen — grid of item slots with item icon, name, quantity, rarity.
-- Lives in StarterPlayerScripts.Client.UI.InventoryScreen
--
-- Figma style: framed panel with title, left equipment column, right item
-- grid, gold count along the bottom. Supports variants A/B/C.
-- Placeholder visuals: colored slot frames, "?" icons, sample items when the
-- server hasn't sent anything yet.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local InventoryScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local grid
local goldLabel
local hasServerItems = false

local GRID_COLUMNS = 6
local GRID_ROWS = 5

local EQUIP_SLOTS = { "Weapon", "Head", "Body", "Legs", "Feet", "Trinket" }

-- Sample items so the screen is functional before the server inventory exists
local SAMPLE_ITEMS = {
	{ name = "Scarlet Sword", icon = "S", tier = "Legendary", quantity = 1 },
	{ name = "Candy Apple", icon = "A", tier = "Common", quantity = 12 },
	{ name = "Slime Pudding", icon = "P", tier = "Common", quantity = 5 },
	{ name = "Ice Shuriken", icon = "I", tier = "Rare", quantity = 30 },
	{ name = "Royal Tart", icon = "T", tier = "Epic", quantity = 2 },
	{ name = "Enchiridion Page", icon = "E", tier = "Mythic", quantity = 1 },
	{ name = "Rope", icon = "R", tier = "Common", quantity = 3 },
	{ name = "Fire Gem", icon = "F", tier = "Rare", quantity = 7 },
}

local function tierColor(tier: string): Color3
	local c = Theme.Colors :: any
	return c[tier] or Theme.Colors.Common
end

local function makeSlot(parent: Instance, name: string, borderColor: Color3?)
	local slot = UiUtil.makeFrame(name, UDim2.fromScale(1, 1), UDim2.new(0, 0, 0, 0), style.Slot, parent)

	local corner = slot:FindFirstChildOfClass("UICorner")
	if corner then
		corner.CornerRadius = UDim.new(0.12, 0)
	end

	local stroke = Instance.new("UIStroke")
	stroke.Color = borderColor or style.Border
	stroke.Thickness = if borderColor then 2 else math.max(style.BorderThickness, 1)
	stroke.Transparency = if borderColor then 0.15 else math.max(style.BorderTransparency, 0.55)
	stroke.Parent = slot

	return slot
end

local function build()
	gui = UiUtil.makeScreenGui("Inventory", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.7, 0, 0.8, 0),
		UDim2.new(0.15, 0, 0.1, 0),
		style.Panel,
		overlay
	)
	UiUtil.applyPanelStyle(panel, style)

	UiUtil.makeTitleBar(panel, "INVENTORY", style, function()
		InventoryScreen.Hide()
	end)

	-- Left column: equipment slots
	local equipPanel = UiUtil.makeFrame(
		"Equipment",
		UDim2.new(0.24, 0, 0.72, 0),
		UDim2.new(0.04, 0, 0.13, 0),
		style.PanelAlt,
		panel
	)
	UiUtil.applyPanelStyle(equipPanel, style)
	equipPanel.BackgroundColor3 = style.PanelAlt

	UiUtil.makeLabel(
		"EquipTitle",
		"EQUIPMENT",
		UDim2.new(1, 0, 0.08, 0),
		UDim2.new(0, 0, 0.01, 0),
		style.Accent,
		equipPanel,
		Theme.Fonts.Header
	)

	local equipGrid = Instance.new("Frame")
	equipGrid.Name = "EquipGrid"
	equipGrid.Size = UDim2.new(0.8, 0, 0.86, 0)
	equipGrid.Position = UDim2.new(0.1, 0, 0.11, 0)
	equipGrid.BackgroundTransparency = 1
	equipGrid.Parent = equipPanel

	local equipLayout = Instance.new("UIGridLayout")
	equipLayout.CellSize = UDim2.new(0.45, 0, 0.3, 0)
	equipLayout.CellPadding = UDim2.new(0.1, 0, 0.03, 0)
	equipLayout.SortOrder = Enum.SortOrder.LayoutOrder
	equipLayout.Parent = equipGrid

	for i, slotName in ipairs(EQUIP_SLOTS) do
		local slot = makeSlot(equipGrid, "Equip" .. slotName)
		slot.LayoutOrder = i
		UiUtil.makeLabel(
			"SlotName",
			slotName,
			UDim2.new(1, 0, 0.35, 0),
			UDim2.new(0, 0, 0.32, 0),
			Theme.Colors.TextMuted,
			slot,
			Theme.Fonts.Body
		)
	end

	-- Right: item grid container
	local gridContainer = UiUtil.makeFrame(
		"GridContainer",
		UDim2.new(0.64, 0, 0.72, 0),
		UDim2.new(0.32, 0, 0.13, 0),
		style.PanelAlt,
		panel
	)
	UiUtil.applyPanelStyle(gridContainer, style)
	gridContainer.BackgroundColor3 = style.PanelAlt

	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(0.148, 0, 0.175, 0)
	layout.CellPadding = UDim2.new(0.012, 0, 0.035, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = gridContainer

	grid = gridContainer

	-- Bottom bar: gold
	local bottomBar = UiUtil.makeFrame(
		"BottomBar",
		UDim2.new(0.92, 0, 0.07, 0),
		UDim2.new(0.04, 0, 0.88, 0),
		style.PanelAlt,
		panel
	)
	UiUtil.applyPanelStyle(bottomBar, style)
	bottomBar.BackgroundColor3 = style.PanelAlt

	goldLabel = UiUtil.makeLabel(
		"Gold",
		"Gold: 0",
		UDim2.new(0.3, 0, 1, 0),
		UDim2.new(0.02, 0, 0, 0),
		Theme.Colors.AccentGold,
		bottomBar,
		Theme.Fonts.Header
	)
	goldLabel.TextXAlignment = Enum.TextXAlignment.Left

	UiUtil.makeLabel(
		"Capacity",
		("Slots: %d/%d"):format(#SAMPLE_ITEMS, GRID_COLUMNS * GRID_ROWS),
		UDim2.new(0.3, 0, 1, 0),
		UDim2.new(0.68, 0, 0, 0),
		Theme.Colors.TextMuted,
		bottomBar,
		Theme.Fonts.Body
	)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false
end

-- Fill the grid: item slots first, then empty placeholder slots.
local function populate(items: { any })
	for _, child in ipairs(grid:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local totalSlots = GRID_COLUMNS * GRID_ROWS
	for i = 1, totalSlots do
		local item = items[i]
		local slot
		if item then
			slot = makeSlot(grid, "Slot" .. i, tierColor(item.tier or "Common"))
			UiUtil.makeLabel(
				"Icon",
				item.icon or "?",
				UDim2.new(1, 0, 0.55, 0),
				UDim2.new(0, 0, 0, 0),
				Theme.Colors.TextPrimary,
				slot,
				Theme.Fonts.Header
			)
			UiUtil.makeLabel(
				"Name",
				item.name or "Item",
				UDim2.new(1, 0, 0.25, 0),
				UDim2.new(0, 0, 0.55, 0),
				Theme.Colors.TextSecondary,
				slot,
				Theme.Fonts.Body
			)
			local qty = UiUtil.makeLabel(
				"Qty",
				"x" .. tostring(item.quantity or 1),
				UDim2.new(0.45, 0, 0.2, 0),
				UDim2.new(0.52, 0, 0.78, 0),
				style.Accent,
				slot,
				Theme.Fonts.Header
			)
			qty.TextXAlignment = Enum.TextXAlignment.Right
		else
			slot = makeSlot(grid, "Slot" .. i)
			slot.BackgroundTransparency = 0.4
		end
		slot.LayoutOrder = i
	end
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function InventoryScreen.Init(variant: string?)
	local newStyle = Theme.GetVariant(variant)
	if gui and newStyle == style then
		return
	end
	style = newStyle
	if gui then
		gui:Destroy()
		gui = nil
	end
	build()
	populate(SAMPLE_ITEMS)
end

-- Populate the grid with items (called from server inventory sync)
function InventoryScreen.SetItems(items: { any })
	hasServerItems = true
	if not gui then
		InventoryScreen.Init()
	end
	populate(items)
end

function InventoryScreen.Show()
	if not gui then
		InventoryScreen.Init()
	end
	gui.Enabled = true
	-- Request inventory from server; sample items stay if the server has none
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer("RequestInventory")
	end
	if not hasServerItems then
		populate(SAMPLE_ITEMS)
	end
end

function InventoryScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return InventoryScreen
