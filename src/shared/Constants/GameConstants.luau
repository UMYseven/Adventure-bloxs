--!strict
-- Shared constants — locked values from the GDD.
-- Lives in ReplicatedStorage.Shared.Constants.GameConstants

export type RaceTier = "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary" | "Mythic"

export type RaceDef = {
	id: string,
	name: string,
	tier: RaceTier,
	archetype: "A" | "B" | "C" | "D" | "E",
	innatePassive: string,
}

-- 19 launch races (locked in GMD §3.1)
local RACES: { [string]: RaceDef } = {
	CandyPerson      = { id = "CandyPerson",      name = "Candy Person",         tier = "Common",   archetype = "B", innatePassive = "CraftFoodFaster" },
	HotDogPerson     = { id = "HotDogPerson",     name = "Hot Dog Person",      tier = "Common",   archetype = "B", innatePassive = "CondimentBonus" },
	Goblin           = { id = "Goblin",           name = "Goblin",              tier = "Common",   archetype = "B", innatePassive = "ScrapScavenge" },
	BoxPerson        = { id = "BoxPerson",        name = "Box Person",          tier = "Common",   archetype = "B", innatePassive = "HiddenCargo" },
	SlimePerson      = { id = "SlimePerson",      name = "Slime Person",        tier = "Uncommon", archetype = "E", innatePassive = "SlimeDrip" },
	Wildberry        = { id = "Wildberry",        name = "Wildberry",           tier = "Uncommon", archetype = "B", innatePassive = "VineCraft" },
	CloudPerson       = { id = "CloudPerson",       name = "Cloud Person",        tier = "Uncommon", archetype = "E", innatePassive = "Float" },
	IcePerson        = { id = "IcePerson",        name = "Ice Person",          tier = "Rare",     archetype = "C", innatePassive = "IceAffinity" },
	FlamePerson      = { id = "FlamePerson",      name = "Fire/Flame Person",   tier = "Rare",     archetype = "C", innatePassive = "FireImmunity" },
	LumpySpacePerson  = { id = "LumpySpacePerson",  name = "Lumpy Space Person",  tier = "Rare",     archetype = "C", innatePassive = "FloatDodge" },
	TreeFolk         = { id = "TreeFolk",         name = "Tree Folk",           tier = "Rare",     archetype = "C", innatePassive = "BarkArmor" },
	CrystalPerson     = { id = "CrystalPerson",     name = "Crystal Person",      tier = "Rare",     archetype = "C", innatePassive = "CrystalFacet" },
	DogMagical       = { id = "DogMagical",       name = "Dog (Magical)",       tier = "Epic",     archetype = "D", innatePassive = "StretchArms" },
	Rainicorn        = { id = "Rainicorn",        name = "Rainicorn",           tier = "Epic",     archetype = "D", innatePassive = "Flight" },
	Ghost            = { id = "Ghost",            name = "Ghost",               tier = "Epic",     archetype = "E", innatePassive = "Phase" },
	WizardHuman       = { id = "WizardHuman",       name = "Wizard-blooded Human", tier = "Epic",  archetype = "A", innatePassive = "ManaRegen" },
	Demon            = { id = "Demon",            name = "Demon (Nightosphere)", tier = "Epic",     archetype = "A", innatePassive = "NightPower" },
	Human            = { id = "Human",            name = "Human (Finn-kin)",    tier = "Legendary", archetype = "A", innatePassive = "HeroXPBonus" },
	Vampire          = { id = "Vampire",          name = "Vampire (Marceline-kin)", tier = "Legendary", archetype = "A", innatePassive = "NightRegen" },
	CosmicTouched    = { id = "CosmicTouched",    name = "Cosmic-touched",      tier = "Legendary", archetype = "A", innatePassive = "RerollLuck" },
}

-- Roll weights per tier (locked, GMD §3.1). Total sums to 1.0.
local TIER_WEIGHTS: { [RaceTier]: number } = {
	Common = 0.50,
	Uncommon = 0.25,
	Rare = 0.15,
	Epic = 0.07,
	Legendary = 0.025,
	Mythic = 0.005,
}

-- 12 bloodlines (locked, GMD §3.2)
local BLOODLINES = {
	Abadeer = { tier = "Epic",     affinity = "Shadow" },
	Petrikov = { tier = "Epic",     affinity = "Ice" },
	Bubblegum = { tier = "Rare",    affinity = "Candy" },
	Mertens = { tier = "Legendary", affinity = "Hero" },
	FlameRoyalty = { tier = "Rare", affinity = "Fire" },
	VampireRoyalty = { tier = "Epic", affinity = "Shadow" },
	Rainicorn = { tier = "Epic",    affinity = "Cosmic" },
	DogMagical = { tier = "Epic",   affinity = "Stretch" },
	WizardGrandmaster = { tier = "Rare", affinity = "Arcane" },
	Cosmic = { tier = "Legendary", affinity = "Cosmic" },
	LichTouched = { tier = "Mythic",  affinity = "Dark" },
	None = { tier = "Common", affinity = "None" },
}

-- 15 talents (locked, GMD §3.3)
local TALENTS = {
	"Hero", "Magic", "Music", "Science", "Stealth",
	"Necromancy", "Pyromancy", "Cryomancy", "Demonology", "Cosmic",
	"BeastTaming", "Healing", "Luck", "Crafting", "Speech",
}

-- Beta elements (locked, COMBAT_DOC §3.5 — core 4 only)
local ELEMENTS = {
	"Fire", "Ice", "Slime", "Candy",
}

-- Beta weapon types (locked, COMBAT_DOC §9.2 — 5 types)
local WEAPONS = {
	"Sword", "Axe", "Staff", "Unarmed", "Bow",
}

-- Beta ability slots (locked, COMBAT_DOC §4.1 — 2 active in beta)
local BETA_ABILITY_SLOTS = 2

-- Beta level cap (locked, COMBAT_DOC §5.4)
local BETA_LEVEL_CAP = 20

-- Candy Kingdom reputation tiers (locked, LOCATIONS_DOC §1.1.6)
local REPUTATION_TIERS = {
	{ name = "Beloved", min = 80,  max = 100 },
	{ name = "Liked",   min = 40,  max = 79 },
	{ name = "Neutral", min = -40, max = 39 },
	{ name = "Disliked", min = -79, max = -41 },
	{ name = "Wanted",  min = -99, max = -80 },
	{ name = "Hunted",  min = -100, max = -100 },
}

-- Sugar Rush tiers (locked, GMD §2A.2)
local SUGAR_RUSH_TIERS = {
	{ tier = 1, candy = 1, buff = { speed = 0.15, strength = 0.15, parkour = 0.15 }, duration = 10, crash = 0 },
	{ tier = 2, candy = 3, buff = { speed = 0.30, strength = 0.30, parkour = 0.30 }, duration = 20, crash = 5 },
	{ tier = 3, candy = 5, buff = { speed = 0.50, strength = 0.50, parkour = 0.50 }, duration = 30, crash = 10 },
	{ tier = 4, candy = 7, buff = { speed = 0.75, strength = 0.75, parkour = 0.75 }, duration = 30, crash = 15, coma = true },
}

return {
	RACES = RACES,
	TIER_WEIGHTS = TIER_WEIGHTS,
	BLOODLINES = BLOODLINES,
	TALENTS = TALENTS,
	ELEMENTS = ELEMENTS,
	WEAPONS = WEAPONS,
	BETA_ABILITY_SLOTS = BETA_ABILITY_SLOTS,
	BETA_LEVEL_CAP = BETA_LEVEL_CAP,
	REPUTATION_TIERS = REPUTATION_TIERS,
	SUGAR_RUSH_TIERS = SUGAR_RUSH_TIERS,
}
