--!strict
-- UI theme — shared colors, fonts, sizes, spacing for all UI screens.
-- Lives in StarterPlayerScripts.Client.UI.Theme
--
-- Every screen should pull from here so the UI stays consistent.
-- Style follows the Figma set: dark panels, gold/yellow Adventure Time
-- accents, white text. Each screen supports 3 visual variants:
--   A = dark / minimal  (flat panels, no borders, muted accents)
--   B = medium          (panel + thin gold border, gold titles, underline)
--   C = ornate/detailed (thicker gold border, corner gems, richest accents)

local Theme = {
	-- Which variant screens use when none is specified.
	DefaultVariant = "B",

	-- Colors
	Colors = {
		-- Base
		Background = Color3.fromRGB(15, 14, 24),
		Panel = Color3.fromRGB(28, 26, 42),
		PanelDark = Color3.fromRGB(18, 17, 28),
		Overlay = Color3.fromRGB(0, 0, 0),

		-- Text
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(210, 205, 225),
		TextMuted = Color3.fromRGB(160, 155, 180),

		-- Accent (gold-first, Adventure Time palette)
		AccentGold = Color3.fromRGB(246, 196, 69),
		AccentGoldDark = Color3.fromRGB(176, 134, 37),
		AccentGreen = Color3.fromRGB(80, 200, 120),
		AccentBlue = Color3.fromRGB(80, 140, 240),
		AccentRed = Color3.fromRGB(200, 80, 80),
		AccentPurple = Color3.fromRGB(140, 100, 200),
		AccentPink = Color3.fromRGB(255, 120, 200),
		AccentTeal = Color3.fromRGB(60, 180, 200),

		-- HUD bar fills
		Health = Color3.fromRGB(220, 70, 70),
		Stamina = Color3.fromRGB(120, 200, 90),
		Hero = Color3.fromRGB(246, 196, 69),
		Sugar = Color3.fromRGB(255, 130, 200),
		XP = Color3.fromRGB(120, 190, 250),

		-- Rarity tiers (from GameConstants)
		Common = Color3.fromRGB(180, 180, 180),
		Uncommon = Color3.fromRGB(80, 200, 80),
		Rare = Color3.fromRGB(80, 140, 240),
		Epic = Color3.fromRGB(180, 80, 240),
		Legendary = Color3.fromRGB(240, 180, 60),
		Mythic = Color3.fromRGB(240, 60, 60),
	},

	-- Fonts
	Fonts = {
		Title = Enum.Font.GothamBlack,
		Header = Enum.Font.GothamBold,
		Body = Enum.Font.GothamMedium,
		BodyLight = Enum.Font.Gotham,
	},

	-- Sizes (as scale fractions)
	Sizes = {
		TitleHeight = 0.08,
		ButtonHeight = 0.1,
		CornerRadius = UDim.new(0.05, 0),
		ButtonCornerRadius = UDim.new(0.2, 0),
	},

	-- Spacing
	Spacing = {
		PanelPadding = 0.05,
		ButtonPadding = 0.05,
		SectionGap = 0.08,
	},

	-- Transparency
	Transparency = {
		Overlay = 0.5,
		Panel = 0.1,
	},
}

-- Per-variant visual styles. Screens call Theme.GetVariant(name) and pass the
-- result to UiUtil.applyPanelStyle / makeTitleBar etc.
local VARIANTS = {
	-- A: dark / minimal — flat panels, no visible border, muted gold text
	A = {
		Panel = Color3.fromRGB(14, 13, 22),
		PanelAlt = Color3.fromRGB(22, 21, 34),
		Slot = Color3.fromRGB(32, 30, 48),
		Border = Color3.fromRGB(90, 80, 50),
		BorderThickness = 0,
		BorderTransparency = 1,
		CornerRadius = UDim.new(0.04, 0),
		TitleColor = Color3.fromRGB(232, 214, 165),
		Accent = Color3.fromRGB(200, 170, 90),
		Underline = false,
		Decorations = false,
		ButtonColor = Color3.fromRGB(52, 46, 38),
	},
	-- B: medium — panel + thin gold border, bright gold titles, underline
	B = {
		Panel = Color3.fromRGB(26, 24, 40),
		PanelAlt = Color3.fromRGB(34, 31, 52),
		Slot = Color3.fromRGB(44, 40, 64),
		Border = Color3.fromRGB(190, 155, 70),
		BorderThickness = 1,
		BorderTransparency = 0.3,
		CornerRadius = UDim.new(0.05, 0),
		TitleColor = Color3.fromRGB(246, 196, 69),
		Accent = Color3.fromRGB(246, 196, 69),
		Underline = true,
		Decorations = false,
		ButtonColor = Color3.fromRGB(64, 54, 40),
	},
	-- C: ornate / detailed — thick gold border, corner gems, richest accents
	C = {
		Panel = Color3.fromRGB(30, 25, 48),
		PanelAlt = Color3.fromRGB(40, 33, 62),
		Slot = Color3.fromRGB(52, 43, 76),
		Border = Color3.fromRGB(255, 205, 70),
		BorderThickness = 2,
		BorderTransparency = 0,
		CornerRadius = UDim.new(0.08, 0),
		TitleColor = Color3.fromRGB(255, 210, 80),
		Accent = Color3.fromRGB(255, 195, 60),
		Underline = true,
		Decorations = true,
		ButtonColor = Color3.fromRGB(88, 68, 32),
	},
}

Theme.Variants = VARIANTS

export type VariantStyle = typeof(VARIANTS.B)

-- Resolve a variant name ("A" | "B" | "C") to its style table. Defaults to B.
function Theme.GetVariant(variant: string?): VariantStyle
	if variant and VARIANTS[variant] then
		return VARIANTS[variant]
	end
	return VARIANTS[Theme.DefaultVariant]
end

return Theme
