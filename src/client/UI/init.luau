--!strict
-- UI system — listens for events and shows the appropriate screen.
-- Lives in StarterPlayerScripts.Client.UI.Init

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Theme = require(script:WaitForChild("Theme"))
local RNGScreen = require(script:WaitForChild("RNGScreen"))
local PauseMenu = require(script:WaitForChild("PauseMenu"))
local Keybinds = require(script:WaitForChild("Keybinds"))
local InventoryScreen = require(script:WaitForChild("InventoryScreen"))
local QuestLogScreen = require(script:WaitForChild("QuestLogScreen"))
local SettingsScreen = require(script:WaitForChild("SettingsScreen"))
local MapScreen = require(script:WaitForChild("MapScreen"))
local DialogScreen = require(script:WaitForChild("DialogScreen"))
local TalentTreeScreen = require(script:WaitForChild("TalentTreeScreen"))
local ShopScreen = require(script:WaitForChild("ShopScreen"))
local DuelScreen = require(script:WaitForChild("DuelScreen"))
local DeathScreen = require(script:WaitForChild("DeathScreen"))
local FounderScreen = require(script:WaitForChild("FounderScreen"))
local LichFinaleScreen = require(script:WaitForChild("LichFinaleScreen"))

local UI = {}

function UI.Init(variant: string?)
	-- Visual variant for all Figma-based screens ("A" | "B" | "C")
	local v = variant or Theme.DefaultVariant

	-- Create the OpenUIScreen BindableEvent if missing
	if not ReplicatedStorage:FindFirstChild("OpenUIScreen") then
		local ev = Instance.new("BindableEvent")
		ev.Name = "OpenUIScreen"
		ev.Parent = ReplicatedStorage
	end
	local openEvent = ReplicatedStorage:WaitForChild("OpenUIScreen")

	-- Build the Figma-based screens (hidden until shown)
	InventoryScreen.Init(v)
	QuestLogScreen.Init(v)
	SettingsScreen.Init(v)
	MapScreen.Init(v)
	DialogScreen.Init(v)
	TalentTreeScreen.Init(v)

	-- Pause menu (Esc) initializes its own input hook
	PauseMenu.Init()

	-- UI keybinds (M=Map, I=Inventory, J=QuestLog, F=Settings, K=Talents, P=Founder)
	Keybinds.Init()

	-- Track which screens are currently open (for toggle behavior)
	local openScreens: { [string]: boolean } = {}

	-- Dispatch OpenUIScreen events to the right screen (toggle on/off)
	openEvent.Event:Connect(function(screenName: string)
		if screenName == "Inventory" then
			if openScreens.Inventory then
				InventoryScreen.Hide()
				openScreens.Inventory = false
			else
				InventoryScreen.Show()
				openScreens.Inventory = true
			end
		elseif screenName == "QuestLog" then
			if openScreens.QuestLog then
				QuestLogScreen.Hide()
				openScreens.QuestLog = false
			else
				QuestLogScreen.Show()
				openScreens.QuestLog = true
			end
		elseif screenName == "Settings" then
			if openScreens.Settings then
				SettingsScreen.Hide()
				openScreens.Settings = false
			else
				SettingsScreen.Show()
				openScreens.Settings = true
			end
		elseif screenName == "Map" then
			if openScreens.Map then
				MapScreen.Hide()
				openScreens.Map = false
			else
				MapScreen.Show()
				openScreens.Map = true
			end
		elseif screenName == "TalentTree" then
			if openScreens.TalentTree then
				TalentTreeScreen.Hide()
				openScreens.TalentTree = false
			else
				TalentTreeScreen.Show()
				openScreens.TalentTree = true
			end
		elseif screenName == "Founder" then
			if openScreens.Founder then
				FounderScreen.Hide()
				openScreens.Founder = false
			else
				FounderScreen.Show()
				openScreens.Founder = true
			end
		end
	end)

	-- Listen for ServerToClient events that trigger UI
	local s2c = ReplicatedStorage:WaitForChild("ServerToClient")
	s2c.OnClientEvent:Connect(function(action: string, payload: any)
		if action == "RNGResult" then
			RNGScreen.Show(payload)
		elseif action == "Dialog" then
			DialogScreen.Show(payload)
		elseif action == "ShopItems" then
			ShopScreen.SetItems(payload)
		elseif action == "ShopGold" then
			ShopScreen.SetGold(payload)
		elseif action == "InventoryItems" then
			InventoryScreen.SetItems(payload)
		elseif action == "Quests" then
			QuestLogScreen.SetQuests(payload.active or {}, payload.completed or {})
		elseif action == "DuelRequest" then
			DuelScreen.Show(payload.challenger or "Unknown")
		elseif action == "Death" then
			DeathScreen.Show(payload)
		elseif action == "FounderStatus" then
			FounderScreen.SetStatus(payload.text or "", payload.success or false)
		elseif action == "LichOmen" then
			LichFinaleScreen.Show(payload.countdown)
		end
	end)

	-- Request our data on join (server will fire RNGResult if firstSpawn)
	local requestFn = ReplicatedStorage:FindFirstChild("RequestPlayerData")
	if requestFn and requestFn:IsA("RemoteFunction") then
		task.spawn(function()
			local ok, result = pcall(function()
				return requestFn:InvokeServer()
			end)
			if ok and type(result) == "table" and result.firstSpawn then
				RNGScreen.Show({
					race = result.race,
					bloodline = result.bloodline,
					talent = result.talent,
				})
			end
		end)
	end

	print("[UI] initialized")
end

return UI
