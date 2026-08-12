--!strict
-- Client bootstrap — controls the full join flow:
--   1. LoadingScreen shows + ContentProvider preloads all assets
--   2. LoadingScreen hides
--   3. RNG character creation shows (if firstSpawn)
--   4. Player confirms → spawns in Candy Kingdom → all other systems init
--
-- Lives in StarterPlayerScripts.Client.Core.Bootstrap

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoadingScreen = require(script.Parent.Parent.UI.LoadingScreen)

local SYSTEMS = {
	"Input",
	"Camera",
	"Combat",
	"HUD",
	"UI",
	"Interaction",
}

-- Load all systems (called after preload + RNG done)
local function loadSystems()
	for _, name in ipairs(SYSTEMS) do
		-- Systems are siblings of Core (which holds this Bootstrap), so look in script.Parent.Parent (the Client folder)
		local systemScript = script.Parent.Parent:FindFirstChild(name)
		if not systemScript then
			warn(("[Client Bootstrap] system folder missing: %s"):format(name))
			continue
		end

		local initModule = systemScript:FindFirstChild("Init")
		if not initModule then
			warn(("[Client Bootstrap] %s missing Init module"):format(name))
			continue
		end

		local ok, result = pcall(function()
			return require(initModule)
		end)
		if not ok then
			warn(("[Client Bootstrap] %s require error: %s"):format(name, tostring(result)))
			continue
		end

		if type(result) == "table" and type(result.Init) == "function" then
			pcall(function()
				result:Init()
			end)
			print(("[Client Bootstrap] %s initialized"):format(name))
		end
	end

	print("[Client Bootstrap] all systems loaded")
end

-- Main flow: preload → (server sends RNGResult if firstSpawn) → load systems
local function main()
	-- Step 1: Show loading screen and preload everything
	LoadingScreen.Show()
	LoadingScreen.PreloadAll(function()
		-- Step 2: Preload done — request our player data from server
		-- The server will fire ServerToClient "RNGResult" if firstSpawn,
		-- which UI Init listens for and shows the RNG screen.
		-- We load systems AFTER the RNG screen is confirmed (or if not firstSpawn).

		-- Check if we're already past character creation (returning player)
		local requestFn = ReplicatedStorage:FindFirstChild("RequestPlayerData")
		if requestFn and requestFn:IsA("RemoteFunction") then
			task.spawn(function()
				local ok, result = pcall(function()
					return requestFn:InvokeServer()
				end)
				if not ok then
					loadSystems()
					return
				end
				if type(result) ~= "table" then
					loadSystems()
					return
				end
				-- First spawn → RNG screen shows via UI Init's ServerToClient listener.
				-- Returning player → spawn directly.
				loadSystems()
			end)
		else
			loadSystems()
		end
	end)
end

main()
