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

-- Load order matters: DataStore -> RNG -> Reputation -> Combat -> SugarRush -> Guards -> Dungeon -> Quests -> Spawns -> Shop
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
	"Shop",
}

print("[Bootstrap] ===== SERVER BOOTSTRAP STARTING =====")
print("[Bootstrap] RemotesSetup complete")

for _, name in ipairs(SYSTEMS) do
	local systemFolder = Server:FindFirstChild(name)
	if not systemFolder then
		warn(("[Bootstrap] system folder missing: %s"):format(name))
		continue
	end

	-- With Rojo, a folder containing init.luau syncs AS a ModuleScript (the folder
	-- itself is the module). Fall back to a child Init only if it stayed a Folder.
	local initModule: Instance?
	if systemFolder:IsA("ModuleScript") then
		initModule = systemFolder
	else
		initModule = systemFolder:FindFirstChild("init") or systemFolder:FindFirstChild("Init")
	end
	if not initModule then
		warn(("[Bootstrap] %s missing init module"):format(name))
		continue
	end

	print(("[Bootstrap] Loading %s..."):format(name))
	local ok, result = pcall(function()
		return require(initModule :: ModuleScript)
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

print("[Bootstrap] ===== SERVER BOOTSTRAP COMPLETE =====")
