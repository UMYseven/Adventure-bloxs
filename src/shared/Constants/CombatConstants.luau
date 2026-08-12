--!strict
-- Combat constants — locked values from COMBAT_DOC.md.
-- Lives in ReplicatedStorage.Shared.Constants.CombatConstants

-- Parry window (locked, COMBAT_DOC §3.2)
local PARRY_WINDOW = 0.3

-- Dodge i-frames (locked, COMBAT_DOC §3.2)
local DODGE_IFRAMES = 0.4

-- Block damage reduction (locked, COMBAT_DOC §3.2)
local BLOCK_DAMAGE_REDUCTION = 0.7

-- Hero Mode (locked, COMBAT_DOC §3.4)
local HERO_MODE_DURATION = 10
local HERO_MODE_DAMAGE_BONUS = 0.5
local HERO_METER_MAX = 100

-- Stamina (locked, COMBAT_DOC §3.3)
local STAMINA_REGEN_RATE = 15 -- per second (medium)
local STAMINA_DODGE_COST = 20
local STAMINA_BLOCK_DRAIN_PER_HIT = 10
local STAMINA_LIGHT_ATTACK_COST = 5
local STAMINA_HEAVY_ATTACK_COST = 15

-- Combo (locked, COMBAT_DOC §3.1)
local COMBO_MAX_MULTIPLIER = 3
local COMBO_HITS_TO_MAX = 10

-- Death penalty (locked, COMBAT_DOC §8.3)
local DEATH_GOLD_LOSS = 0.10
local DEATH_XP_DEBT_RATE = 0.5 -- portion of XP that goes to debt payoff

-- Elemental affinities (locked, COMBAT_DOC §3.5 — beta core 4)
local ELEMENT_STRONG_VS = {
	Fire = { "Ice", "Slime" },
	Ice = { "Fire" },
	Slime = { "Ice" },
	Candy = {},
}

local ELEMENT_STATUS = {
	Fire = "Burn",
	Ice = "Freeze",
	Slime = "Stick",
	Candy = "Sugar",
}

-- Weapon types (locked, COMBAT_DOC §9.2 — beta 5)
local WEAPONS = {
	"Sword", "Axe", "Staff", "Unarmed", "Bow",
}

-- Beta ability slots (locked, COMBAT_DOC §4.1)
local BETA_ABILITY_SLOTS = 2

return {
	PARRY_WINDOW = PARRY_WINDOW,
	DODGE_IFRAMES = DODGE_IFRAMES,
	BLOCK_DAMAGE_REDUCTION = BLOCK_DAMAGE_REDUCTION,
	HERO_MODE_DURATION = HERO_MODE_DURATION,
	HERO_MODE_DAMAGE_BONUS = HERO_MODE_DAMAGE_BONUS,
	HERO_METER_MAX = HERO_METER_MAX,
	STAMINA_REGEN_RATE = STAMINA_REGEN_RATE,
	STAMINA_DODGE_COST = STAMINA_DODGE_COST,
	STAMINA_BLOCK_DRAIN_PER_HIT = STAMINA_BLOCK_DRAIN_PER_HIT,
	STAMINA_LIGHT_ATTACK_COST = STAMINA_LIGHT_ATTACK_COST,
	STAMINA_HEAVY_ATTACK_COST = STAMINA_HEAVY_ATTACK_COST,
	COMBO_MAX_MULTIPLIER = COMBO_MAX_MULTIPLIER,
	COMBO_HITS_TO_MAX = COMBO_HITS_TO_MAX,
	DEATH_GOLD_LOSS = DEATH_GOLD_LOSS,
	DEATH_XP_DEBT_RATE = DEATH_XP_DEBT_RATE,
	ELEMENT_STRONG_VS = ELEMENT_STRONG_VS,
	ELEMENT_STATUS = ELEMENT_STATUS,
	WEAPONS = WEAPONS,
	BETA_ABILITY_SLOTS = BETA_ABILITY_SLOTS,
}
