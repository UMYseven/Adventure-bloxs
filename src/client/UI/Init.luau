--!strict
-- UI system — listens for RNG result and shows the character creation screen.
-- Lives in StarterPlayerScripts.Client.UI.Init

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RNGScreen = require(script.Parent:WaitForChild("RNGScreen"))

local UI = {}

function UI.Init()
	-- Listen for ServerToClient RNGResult event
	local s2c = ReplicatedStorage:WaitForChild("ServerToClient")
	s2c.OnClientEvent:Connect(function(action: string, payload: any)
		if action == "RNGResult" then
			RNGScreen.Show(payload)
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
				-- Server should also fire via ServerToClient, but as a fallback show directly
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
