--!strict
-- Talent tree screen — 3 branches of skill nodes connected by lines.
-- Lives in StarterPlayerScripts.Client.UI.TalentTreeScreen
--
-- Figma style: framed panel, gold title, 3 vertical branches of circular
-- nodes, points counter up top, detail panel at the bottom with an Unlock
-- button. Supports variants A/B/C.
-- Placeholder visuals: colored frames; node states = locked/available/unlocked.
-- Talent names come from GameConstants (locked list, GMD §3.3).

local Players = game:GetService("Players")

local Theme = require(script.Parent:WaitForChild("Theme"))
local UiUtil = require(script.Parent:WaitForChild("UiUtil"))

local TalentTreeScreen = {}

local gui
local style = Theme.GetVariant(Theme.DefaultVariant)
local pointsLabel
local detailName
local detailDesc
local detailCost
local unlockBtn

-- Placeholder progression state (server sync comes later)
local pointsAvailable = 5
local unlockedNodes = {} :: { [string]: boolean }
local selectedNode: string? = nil

-- 3 branches x 5 nodes. requires = points already spent in that branch.
-- Names pulled from the locked GameConstants.TALENTS list.
local BRANCHES = {
	{
		id = "Hero",
		title = "HERO",
		color = Theme.Colors.AccentGold,
		nodes = {
			{ id = "Hero1", name = "Hero", desc = "+10% damage with swords.", cost = 1, requires = 0 },
			{ id = "Hero2", name = "Beast Taming", desc = "Wild mobs may fight beside you.", cost = 1, requires = 1 },
			{ id = "Hero3", name = "Luck", desc = "Better roll odds on rare drops.", cost = 1, requires = 2 },
			{ id = "Hero4", name = "Speech", desc = "New dialogue options with NPCs.", cost = 2, requires = 3 },
			{ id = "Hero5", name = "Hero's Heart", desc = "Hero meter fills 25% faster.", cost = 2, requires = 4 },
		},
	},
	{
		id = "Arcane",
		title = "ARCANE",
		color = Theme.Colors.AccentPurple,
		nodes = {
			{ id = "Arcane1", name = "Magic", desc = "Unlock basic spellcasting.", cost = 1, requires = 0 },
			{ id = "Arcane2", name = "Pyromancy", desc = "Fire spells deal +15% damage.", cost = 1, requires = 1 },
			{ id = "Arcane3", name = "Cryomancy", desc = "Ice spells slow enemies.", cost = 1, requires = 2 },
			{ id = "Arcane4", name = "Necromancy", desc = "Raise a fallen foe once per battle.", cost = 2, requires = 3 },
			{ id = "Arcane5", name = "Cosmic", desc = "Cosmic Owl's blessing: +1 reroll.", cost = 2, requires = 4 },
		},
	},
	{
		id = "Craft",
		title = "CRAFT",
		color = Theme.Colors.AccentTeal,
		nodes = {
			{ id = "Craft1", name = "Science", desc = "Craft gadgets at workbenches.", cost = 1, requires = 0 },
			{ id = "Craft2", name = "Music", desc = "Songs buff nearby allies.", cost = 1, requires = 1 },
			{ id = "Craft3", name = "Healing", desc = "Healing items restore +20%.", cost = 1, requires = 2 },
			{ id = "Craft4", name = "Crafting", desc = "Unlock rare crafting recipes.", cost = 2, requires = 3 },
			{ id = "Craft5", name = "Stealth", desc = "Guards notice you more slowly.", cost = 2, requires = 4 },
		},
	},
}

-- Points spent in one branch (drives requires-checks).
local function branchSpent(branch: any): number
	local spent = 0
	for _, node in ipairs(branch.nodes) do
		if unlockedNodes[node.id] then
			spent += node.cost
		end
	end
	return spent
end

local function nodeState(branch: any, node: any): string
	if unlockedNodes[node.id] then
		return "unlocked"
	end
	if branchSpent(branch) >= node.requires and pointsAvailable >= node.cost then
		return "available"
	end
	return "locked"
end

local function refreshDetail()
	if not gui then
		return
	end
	pointsLabel.Text = ("Talent Points: %d"):format(pointsAvailable)

	local foundBranch, foundNode
	for _, branch in ipairs(BRANCHES) do
		for _, node in ipairs(branch.nodes) do
			if node.id == selectedNode then
				foundBranch, foundNode = branch, node
				break
			end
		end
	end

	if not foundNode then
		detailName.Text = "Select a node"
		detailDesc.Text = ""
		detailCost.Text = ""
		unlockBtn.Visible = false
		return
	end

	local state = nodeState(foundBranch, foundNode)
	detailName.Text = foundNode.name
	detailDesc.Text = foundNode.desc
	detailCost.Text = ("Cost: %d point%s"):format(foundNode.cost, if foundNode.cost == 1 then "" else "s")

	unlockBtn.Visible = state == "available"
	if state == "unlocked" then
		detailCost.Text = "Unlocked"
	elseif state == "locked" then
		detailCost.Text ..= "  (locked)"
	end
end

local function refreshTree(treeArea: Instance)
	for _, branch in ipairs(BRANCHES) do
		for _, node in ipairs(branch.nodes) do
			local btn = treeArea:FindFirstChild(node.id, true)
			if btn and btn:IsA("TextButton") then
				local state = nodeState(branch, node)
				if state == "unlocked" then
					btn.BackgroundColor3 = branch.color
				elseif state == "available" then
					btn.BackgroundColor3 = style.Slot
				else
					btn.BackgroundColor3 = Theme.Colors.PanelDark
				end
				local stroke = btn:FindFirstChildOfClass("UIStroke")
				if stroke then
					stroke.Color = if state == "locked" then Theme.Colors.TextMuted else branch.color
					stroke.Transparency = if state == "locked" then 0.5 else 0
				end
			end
		end
	end
	refreshDetail()
end

local function build()
	gui = UiUtil.makeScreenGui("TalentTree", 70)

	local overlay = UiUtil.makeOverlay(gui)

	local panel = UiUtil.makeFrame(
		"Panel",
		UDim2.new(0.72, 0, 0.82, 0),
		UDim2.new(0.14, 0, 0.09, 0),
		style.Panel,
		overlay
	)
	UiUtil.applyPanelStyle(panel, style)

	UiUtil.makeTitleBar(panel, "TALENT TREE", style, function()
		TalentTreeScreen.Hide()
	end)

	-- Points counter (top-left)
	pointsLabel = UiUtil.makeLabel(
		"Points",
		("Talent Points: %d"):format(pointsAvailable),
		UDim2.new(0.3, 0, 0.05, 0),
		UDim2.new(0.04, 0, 0.115, 0),
		style.Accent,
		panel,
		Theme.Fonts.Header
	)
	pointsLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Tree area: 3 branch columns
	local treeArea = UiUtil.makeFrame(
		"TreeArea",
		UDim2.new(0.92, 0, 0.56, 0),
		UDim2.new(0.04, 0, 0.18, 0),
		style.PanelAlt,
		panel
	)
	UiUtil.applyPanelStyle(treeArea, style)
	treeArea.BackgroundColor3 = style.PanelAlt

	for b, branch in ipairs(BRANCHES) do
		local colX = (b - 1) * 0.333 + 0.045

		-- Branch header
		UiUtil.makeLabel(
			"Branch" .. branch.id,
			branch.title,
			UDim2.new(0.26, 0, 0.07, 0),
			UDim2.new(colX, 0, 0.02, 0),
			branch.color,
			treeArea,
			Theme.Fonts.Header
		)

		-- Connector line behind the nodes (vertical spine)
		local spine = Instance.new("Frame")
		spine.Name = "Spine" .. branch.id
		spine.Size = UDim2.new(0, 3, 0.78, 0)
		spine.Position = UDim2.new(colX + 0.13, 0, 0.12, 0)
		spine.AnchorPoint = Vector2.new(0.5, 0)
		spine.BackgroundColor3 = style.Border
		spine.BackgroundTransparency = if style.BorderThickness > 0 then 0.4 else 0.7
		spine.BorderSizePixel = 0
		spine.Parent = treeArea

		for n, node in ipairs(BRANCHES[b].nodes) do
			local y = 0.1 + (n - 1) * 0.175

			-- Circular node button
			local btn = UiUtil.makeButton(
				node.id,
				tostring(n),
				UDim2.new(0, 44, 0, 44),
				UDim2.new(colX + 0.13, -22, y, 0),
				Theme.Colors.PanelDark,
				treeArea
			)
			btn.TextColor3 = Theme.Colors.TextPrimary

			local btnCorner = btn:FindFirstChildOfClass("UICorner")
			if btnCorner then
				btnCorner.CornerRadius = UDim.new(0.5, 0)
			end

			local stroke = Instance.new("UIStroke")
			stroke.Color = Theme.Colors.TextMuted
			stroke.Thickness = 2
			stroke.Transparency = 0.5
			stroke.Parent = btn

			-- Node label to the right of the circle
			local nameLabel = UiUtil.makeLabel(
				"Name",
				node.name,
				UDim2.new(0.2, 0, 0.09, 0),
				UDim2.new(colX + 0.13, 28, y + 0.02, 0),
				Theme.Colors.TextSecondary,
				treeArea,
				Theme.Fonts.Body
			)
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left

			btn.MouseButton1Click:Connect(function()
				selectedNode = node.id
				refreshTree(treeArea)
			end)
		end
	end

	-- Bottom detail panel
	local detail = UiUtil.makeFrame(
		"Detail",
		UDim2.new(0.92, 0, 0.2, 0),
		UDim2.new(0.04, 0, 0.77, 0),
		style.PanelAlt,
		panel
	)
	UiUtil.applyPanelStyle(detail, style)
	detail.BackgroundColor3 = style.PanelAlt

	detailName = UiUtil.makeLabel(
		"Name",
		"Select a node",
		UDim2.new(0.5, 0, 0.3, 0),
		UDim2.new(0.03, 0, 0.05, 0),
		style.TitleColor,
		detail,
		Theme.Fonts.Header
	)
	detailName.TextXAlignment = Enum.TextXAlignment.Left

	detailDesc = UiUtil.makeLabel(
		"Desc",
		"",
		UDim2.new(0.6, 0, 0.4, 0),
		UDim2.new(0.03, 0, 0.35, 0),
		Theme.Colors.TextSecondary,
		detail,
		Theme.Fonts.Body
	)
	detailDesc.TextXAlignment = Enum.TextXAlignment.Left
	detailDesc.TextWrapped = true

	detailCost = UiUtil.makeLabel(
		"Cost",
		"",
		UDim2.new(0.5, 0, 0.2, 0),
		UDim2.new(0.03, 0, 0.78, 0),
		style.Accent,
		detail,
		Theme.Fonts.Body
	)
	detailCost.TextXAlignment = Enum.TextXAlignment.Left

	unlockBtn = UiUtil.makeButton(
		"Unlock",
		"UNLOCK",
		UDim2.new(0.22, 0, 0.5, 0),
		UDim2.new(0.74, 0, 0.25, 0),
		Theme.Colors.AccentGold,
		detail
	)
	unlockBtn.TextColor3 = Theme.Colors.PanelDark
	unlockBtn.Visible = false
	unlockBtn.MouseButton1Click:Connect(function()
		if not selectedNode then
			return
		end
		for _, branch in ipairs(BRANCHES) do
			for _, node in ipairs(branch.nodes) do
				if node.id == selectedNode and nodeState(branch, node) == "available" then
					unlockedNodes[node.id] = true
					pointsAvailable -= node.cost
					refreshTree(treeArea)
					return
				end
			end
		end
	end)

	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Enabled = false

	refreshTree(treeArea)
end

-- Initialize with a visual variant ("A" | "B" | "C"). Rebuilds if variant changes.
function TalentTreeScreen.Init(variant: string?)
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
end

-- Server sync hook (placeholder): set available points from player data.
function TalentTreeScreen.SetPoints(points: number)
	pointsAvailable = points
	if gui then
		refreshDetail()
	end
end

function TalentTreeScreen.Show()
	if not gui then
		TalentTreeScreen.Init()
	end
	gui.Enabled = true
	refreshDetail()
end

function TalentTreeScreen.Hide()
	if gui then
		gui.Enabled = false
	end
end

return TalentTreeScreen
