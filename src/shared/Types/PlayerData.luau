--!strict
-- PlayerData type schema — the shape of every player's saved data.
-- Lives in ReplicatedStorage.Shared.Types.PlayerData

export type Bloodline = "Abadeer" | "Petrikov" | "Bubblegum" | "Mertens"
	| "FlameRoyalty" | "VampireRoyalty" | "Rainicorn" | "DogMagical"
	| "WizardGrandmaster" | "Cosmic" | "LichTouched" | "None"

export type Talent = "Hero" | "Magic" | "Music" | "Science" | "Stealth"
	| "Necromancy" | "Pyromancy" | "Cryomancy" | "Demonology" | "Cosmic"
	| "BeastTaming" | "Healing" | "Luck" | "Crafting" | "Speech"

export type Element = "Fire" | "Ice" | "Slime" | "Candy"

export type Weapon = "Sword" | "Axe" | "Staff" | "Unarmed" | "Bow"

export type AbilitySlot = {
	talent: Talent,
	abilityId: string,
	cooldown: number,
}

export type ReputationTier = "Beloved" | "Liked" | "Neutral" | "Disliked" | "Wanted" | "Hunted"

export type KingdomReputation = {
	tier: ReputationTier,
	value: number, -- -100 to 100
}

export type InventoryItem = {
	id: string,
	quantity: number,
	metadata: { [string]: any }?,
}

export type PlayerData = {
	-- Identity
	userId: number,
	username: string,
	race: string,
	bloodline: Bloodline,
	talent: Talent,

	-- Progression
	level: number,
	xp: number,
	xpDebt: number, -- from death penalty (GMD §8.3)
	gold: number,

	-- Combat
	weapon: Weapon,
	abilities: { AbilitySlot }, -- 2 active in beta (GMD §4.1)
	staminaMax: number,
	heroMeter: number, -- 0 to 100, triggers Hero Mode at 100

	-- Reputation (Candy Kingdom only in beta; GMD §2A.3)
	reputation: {
		CandyKingdom: KingdomReputation,
	},

	-- Inventory
	inventory: { InventoryItem },

	-- Sugar Rush (GMD §2A.2)
	sugarMeter: number, -- 0 to 10 (candy eaten)
	sugarRushTier: number, -- 0 (none) to 4 (coma)
	sugarRushUntil: number, -- os.clock() timestamp when rush ends
	sugarCrashUntil: number, -- os.clock() timestamp when crash ends

	-- Housing (Tree Fort, mid-tier in beta; GMD §2B)
	treeFort: {
		decor: { [string]: boolean }, -- owned decor IDs
		upgradedRooms: { string }, -- room IDs unlocked
	},

	-- Beta meta
	isFounder: boolean,
	betaTitle: string?,
	firstSpawn: boolean,

	-- Save metadata
	saveVersion: number,
	lastSavedAt: number,
}

-- Default data for a brand-new player (before RNG roll)
return {
	DEFAULT = {
		userId = 0,
		username = "",
		race = "", -- set by RNG system after spawn
		bloodline = "None",
		talent = "Hero",
		level = 1,
		xp = 0,
		xpDebt = 0,
		gold = 0,
		weapon = "Sword",
		abilities = {},
		staminaMax = 100,
		heroMeter = 0,
		reputation = {
			CandyKingdom = { tier = "Neutral", value = 0 },
		},
		inventory = {},
		sugarMeter = 0,
		sugarRushTier = 0,
		sugarRushUntil = 0,
		sugarCrashUntil = 0,
		treeFort = {
			decor = {},
			upgradedRooms = {},
		},
		isFounder = false,
		betaTitle = nil,
		firstSpawn = true,
		saveVersion = 1,
		lastSavedAt = 0,
	} :: any,
}
