--!strict
-- Server bootstrap — loads all server-side systems for the beta.
-- Lives in ServerScriptService.Server.Core.Bootstrap

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Server = ServerScriptService:WaitForChild("Server")

-- Set up remotes first so systems can rely on them
local RemotesSetup = require(Shared:WaitForChild("Remotes"):WaitForChild("RemotesSetup"))
RemotesSetup.setup()

-- Load order matters: DataStore -> RNG -> Reputation -> Combat -> SugarRush -> Guards -> Dungeon -> Quests -> Spawns
local SYSTEMS = {
	"DataStore",
	"RNG",
	"Reputation",
	"Combat",
	"SugarRush",
	"Guards",
	"Dungeon",
	"Quests",
	"Spawns",
}

for _, name in ipairs(SYSTEMS) do
	local systemFolder = Server:FindFirstChild(name)
	if not systemFolder then
		warn(("[Bootstrap] system folder missing: %s"):format(name))
		continue
	end

	local initModule = systemFolder:FindFirstChild("Init")
	if not initModule then
		warn(("[Bootstrap] %s missing Init module"):format(name))
		continue
	end

	local ok, result = pcall(function()
		return require(initModule)
	end)
	if not ok then
		warn(("[Bootstrap] %s require error: %s"):format(name, tostring(result)))
		continue
	end

	if type(result) == "table" and type(result.Init) == "function" then
		local initOk, initErr = pcall(function()
			result:Init()
		end)
		if initOk then
			print(("[Bootstrap] %s initialized"):format(name))
		else
			warn(("[Bootstrap] %s Init error: %s"):format(name, tostring(initErr)))
		end
	else
		warn(("[Bootstrap] %s Init module has no Init() function"):format(name))
	end
end

print("[Bootstrap] server bootstrap complete")
