--!strict
-- Client bootstrap — loads all client-side systems for the beta.
-- Lives in StarterPlayerScripts.Client.Core.Bootstrap

local SYSTEMS = {
	"Input",
	"Camera",
	"Combat",
	"HUD",
	"UI",
	"Interaction",
}

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

print("[Client Bootstrap] client bootstrap complete")
