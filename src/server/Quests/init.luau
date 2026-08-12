--!strict
-- Quests system — ~10 short beta quests.
-- Lives in ServerScriptService.Server.Quests.Init
--
-- Design (per MVP_BETA_SCOPE):
--   * ~10 short quests, sandbox RPG focus (not linear story)
--   * Quest givers: PB, Peppermint Butler, Starchy, Cinnamon Bun, Tree Trunks (visiting)
--   * Types: fetch, deliver, talk, fight, explore, minigame
--   * Rewards: XP, gold, reputation, sometimes items

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local DataStore = require(ServerScriptService:WaitForChild("Server"):WaitForChild("DataStore"))

local Quests = {}

-- Quest definitions (locked per MVP_BETA_SCOPE §Quests)
local QUEST_DEFS = {
	{
		id = "PB_CandyCount",
		name = "A Candy Count",
		giver = "Princess Bubblegum",
		description = "Count the candy citizens in the town square. Report back to me.",
		type = "talk",
		objective = "Talk to 5 Candy Citizens",
		reward = { xp = 50, gold = 20, rep = 5 },
	},
	{
		id = "Starchy_Water",
		name = "A Rooty Errand",
		giver = "Starchy",
		description = "I'm thirsty! Fetch me a bottle of water from the river.",
		type = "fetch",
		objective = "Collect River Water",
		reward = { xp = 30, gold = 10, rep = 3 },
	},
	{
		id = "CinnamonBun_Message",
		name = "Cinnamon Bun's Message",
		giver = "Cinnamon Bun",
		description = "I dropped my message somewhere in the market. Can you find it?",
		type = "explore",
		objective = "Find Cinnamon Bun's Message",
		reward = { xp = 40, gold = 15, rep = 5 },
	},
	{
		id = "PB_TartVault",
		name = "The Royal Tart Vault",
		giver = "Princess Bubblegum",
		description = "Someone's been sneaking into the vault. Investigate for me.",
		type = "explore",
		objective = "Enter the Royal Tart Vault",
		reward = { xp = 100, gold = 50, rep = 10, item = "RoyalTart" },
	},
	{
		id = "Peppermint_Secret",
		name = "Peppermint Butler's Secret",
		giver = "Peppermint Butler",
		description = "I need a special ingredient. Bring me 3 Sugar Sprouts.",
		type = "fetch",
		objective = "Collect 3 Sugar Sprouts",
		reward = { xp = 60, gold = 30, rep = 5 },
	},
	{
		id = "TreeTrunks_Pie",
		name = "Tree Trunks' Pie",
		giver = "Tree Trunks",
		description = "I'm baking a pie! Bring me 5 Wild Berries from the Grasslands.",
		type = "fetch",
		objective = "Collect 5 Wild Berries",
		reward = { xp = 80, gold = 40, rep = 8 },
	},
	{
		id = "PB_RuinedOutpost",
		name = "What Lies in Ruins",
		giver = "Princess Bubblegum",
		description = "There's a ruined outpost in the Grasslands. Scout it out.",
		type = "explore",
		objective = "Visit the Ruined Outpost",
		reward = { xp = 120, gold = 60, rep = 10 },
	},
	{
		id = "Starchy_Sleep",
		name = "Starchy Needs Sleep",
		giver = "Starchy",
		description = "I'm too tired to work. Find me a Soft Pillow from the residential district.",
		type = "fetch",
		objective = "Find a Soft Pillow",
		reward = { xp = 40, gold = 15, rep = 3 },
	},
	{
		id = "CinnamonBun_Hero",
		name = "Cinnamon Bun's Hero Training",
		giver = "Cinnamon Bun",
		description = "Teach me to be a hero! Show me how to fight.",
		type = "minigame",
		objective = "Win a duel against Cinnamon Bun",
		reward = { xp = 70, gold = 35, rep = 8 },
	},
	{
		id = "PB_Gate",
		name = "Opening the Gates",
		giver = "Princess Bubblegum",
		description = "You've proven yourself. I'll open the Candy Kingdom gates for you.",
		type = "talk",
		objective = "Talk to Princess Bubblegum",
		reward = { xp = 200, gold = 100, rep = 20, unlocksGate = true },
	},
}

-- Per-player quest progress
local questState = {} :: { [number]: { active: { string }, completed: { string } } }

-- Broadcast quest state to client
local function broadcastQuests(player: Player)
	local qs = questState[player.UserId]
	if not qs then
		return
	end
	local active = {}
	local completed = {}
	for _, qid in ipairs(qs.active) do
		local q = nil
		for _, def in ipairs(QUEST_DEFS) do
			if def.id == qid then
				q = def
				break
			end
		end
		if q then
			table.insert(active, {
				id = q.id,
				name = q.name,
				description = q.description,
				objective = q.objective,
				progress = "In progress",
			})
		end
	end
	for _, qid in ipairs(qs.completed) do
		local q = nil
		for _, def in ipairs(QUEST_DEFS) do
			if def.id == qid then
				q = def
				break
			end
		end
		if q then
			table.insert(completed, {
				id = q.id,
				name = q.name,
				description = q.description,
				progress = "Complete",
			})
		end
	end

	local s2c = ReplicatedStorage:FindFirstChild("ServerToClient")
	if s2c and s2c:IsA("RemoteEvent") then
		s2c:FireClient(player, "Quests", { active = active, completed = completed })
	end
end

-- Start a quest for a player
function Quests.Start(player: Player, questId: string): boolean
	local qs = questState[player.UserId]
	if not qs then
		questState[player.UserId] = { active = {}, completed = {} }
		qs = questState[player.UserId]
	end

	-- Check not already active or completed
	for _, q in ipairs(qs.active) do
		if q == questId then
			return false
		end
	end
	for _, q in ipairs(qs.completed) do
		if q == questId then
			return false
		end
	end

	table.insert(qs.active, questId)
	broadcastQuests(player)
	print(("[Quests] %s started quest: %s"):format(player.Name, questId))
	return true
end

-- Complete a quest for a player
function Quests.Complete(player: Player, questId: string): boolean
	local qs = questState[player.UserId]
	if not qs then
		return false
	end

	-- Find and remove from active
	local found = false
	for i, q in ipairs(qs.active) do
		if q == questId then
			table.remove(qs.active, i)
			found = true
			break
		end
	end
	if not found then
		return false
	end

	table.insert(qs.completed, questId)

	-- Apply reward
	local q = nil
	for _, def in ipairs(QUEST_DEFS) do
		if def.id == questId then
			q = def
			break
		end
	end
	if q then
		local data = DataStore.Get(player.UserId)
		if data then
			if q.reward.xp then
				data.xp += q.reward.xp
			end
			if q.reward.gold then
				data.gold += q.reward.gold
			end
			if q.reward.rep then
				local reputation = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Reputation"))
				reputation.Change(player, "CompleteQuest", q.reward.rep)
			end
			DataStore.Set(player.UserId, data)
		end

		-- Gate unlock
		if q.reward.unlocksGate then
			local gate = game.Workspace:FindFirstChild("CandyKingdomGate")
			if gate then
				gate:SetAttribute("Locked", false)
				print(("[Quests] Candy Kingdom gate unlocked for %s"):format(player.Name))
			end
		end
	end

	broadcastQuests(player)
	print(("[Quests] %s completed quest: %s"):format(player.Name, questId))
	return true
end

-- Get all quest definitions (for NPC dialog)
function Quests.GetDefs()
	return QUEST_DEFS
end

-- Handle client actions
local function onClientToServer(player: Player, action: string, payload: any)
	if action == "StartQuest" and payload.questId then
		Quests.Start(player, payload.questId)
	elseif action == "CompleteQuest" and payload.questId then
		Quests.Complete(player, payload.questId)
	elseif action == "RequestQuests" then
		broadcastQuests(player)
	end
end

function Quests.Init()
	-- Hook PlayerDataReady
	local readyEvent = ReplicatedStorage:FindFirstChild("PlayerDataReady")
	if readyEvent and readyEvent:IsA("BindableEvent") then
		readyEvent.Event:Connect(function(player: Player, _data: any)
			questState[player.UserId] = { active = {}, completed = {} }
			broadcastQuests(player)
		end)
	end

	-- Hook ClientToServer
	local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
	if c2s and c2s:IsA("RemoteEvent") then
		c2s.OnServerEvent:Connect(onClientToServer)
	end

	-- Hook player leaving
	Players.PlayerRemoving:Connect(function(player: Player)
		questState[player.UserId] = nil
	end)

	print("[Quests] initialized (" .. #QUEST_DEFS .. " quests defined)")
end

return Quests
