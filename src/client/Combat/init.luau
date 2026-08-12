--!strict
-- Client combat system — visual feedback for combat (hit VFX, hero mode glow, parry flash).
-- Lives in StarterPlayerScripts.Client.Combat.Init
--
-- Listens for ServerToClient combat events and plays placeholder VFX.
-- Real animations/VFX swapped in later.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Combat = {}

local heroGlow

local function buildHeroGlow()
	local player = Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	-- Glow outline when hero mode active
	local hl = Instance.new("Highlight")
	hl.Name = "HeroGlow"
	hl.FillColor = Color3.fromRGB(240, 180, 60)
	hl.FillTransparency = 0.7
	hl.OutlineColor = Color3.fromRGB(255, 220, 100)
	hl.Parent = char
	heroGlow = hl
end

function Combat.Init()
	local s2c = ReplicatedStorage:WaitForChild("ServerToClient")
	s2c.OnClientEvent:Connect(function(action: string, payload: any)
		if action == "Stats" then
			-- Hero mode visual toggle
			if payload.hero and payload.hero >= 100 then
				if not heroGlow then
					buildHeroGlow()
				end
				heroGlow.Enabled = true
			elseif heroGlow then
				heroGlow.Enabled = false
			end
		elseif action == "HitConfirm" or action == "ParrySuccess" then
			-- Placeholder VFX hooks (real VFX swapped in later)
			local _ = payload
		end
	end)

	print("[Client Combat] initialized")
end

return Combat
