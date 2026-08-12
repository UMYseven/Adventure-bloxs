--!strict
-- HUD system — listens for ServerToClient and updates the HUD.
-- Lives in StarterPlayerScripts.Client.HUD.Init

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HUDGui = require(script:WaitForChild("HUDGui"))

local HUD = {}

-- Local mirror of player data (kept in sync via ServerToClient)
local localData = {
	level = 1,
	xp = 0,
	xpToNext = 100,
	gold = 0,
	health = 100,
	healthMax = 100,
	stamina = 100,
	staminaMax = 100,
	hero = 0,
	sugar = 0,
	sugarTier = 0,
	repTier = "Neutral",
}

function HUD.Init()
	-- Build the HUD with the default Figma variant, then show it
	HUDGui.Init("B")
	HUDGui.Show()

	-- Initial values
	HUDGui.UpdateHealth(localData.health, localData.healthMax)
	HUDGui.UpdateStamina(localData.stamina, localData.staminaMax)
	HUDGui.UpdateHero(localData.hero)
	HUDGui.UpdateSugar(localData.sugar, localData.sugarTier)
	HUDGui.UpdateLevel(localData.level, localData.xp, localData.xpToNext)
	HUDGui.UpdateGold(localData.gold)
	HUDGui.UpdateReputation(localData.repTier, 0)

	-- Listen for ServerToClient updates
	local s2c = ReplicatedStorage:WaitForChild("ServerToClient")
	s2c.OnClientEvent:Connect(function(action: string, payload: any)
		if action == "Stats" then
			-- payload: { health, healthMax, stamina, staminaMax, hero, sugar, sugarTier }
			if payload.health and payload.healthMax then
				localData.health = payload.health
				localData.healthMax = payload.healthMax
				HUDGui.UpdateHealth(payload.health, payload.healthMax)
			end
			if payload.stamina and payload.staminaMax then
				localData.stamina = payload.stamina
				localData.staminaMax = payload.staminaMax
				HUDGui.UpdateStamina(payload.stamina, payload.staminaMax)
			end
			if payload.hero then
				localData.hero = payload.hero
				HUDGui.UpdateHero(payload.hero)
			end
			if payload.sugar and payload.sugarTier then
				localData.sugar = payload.sugar
				localData.sugarTier = payload.sugarTier
				HUDGui.UpdateSugar(payload.sugar, payload.sugarTier)
			end
		elseif action == "Progression" then
			-- payload: { level, xp, xpToNext, gold }
			if payload.level then
				localData.level = payload.level
			end
			if payload.xp and payload.xpToNext then
				localData.xp = payload.xp
				localData.xpToNext = payload.xpToNext
			end
			if payload.gold then
				localData.gold = payload.gold
			end
			HUDGui.UpdateLevel(localData.level, localData.xp, localData.xpToNext)
			HUDGui.UpdateGold(localData.gold)
		elseif action == "Reputation" then
			-- payload: { tier, value }
			if payload.tier then
				localData.repTier = payload.tier
				HUDGui.UpdateReputation(payload.tier, payload.value or 0)
			end
		end
	end)

	print("[HUD] initialized")
end

return HUD
