--!strict
-- UI theme — shared colors, fonts, sizes, spacing for all UI screens.
-- Lives in StarterPlayerScripts.Client.UI.Theme
--
-- Every screen should pull from here so the UI stays consistent.

local Theme = {
	-- Colors
	Colors = {
		-- Base
		Background = Color3.fromRGB(20, 20, 35),
		Panel = Color3.fromRGB(30, 30, 45),
		PanelDark = Color3.fromRGB(20, 20, 30),
		Overlay = Color3.fromRGB(0, 0, 0),

		-- Text
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(200, 200, 220),
		TextMuted = Color3.fromRGB(160, 160, 180),

		-- Accent
		AccentGreen = Color3.fromRGB(80, 200, 120),
		AccentBlue = Color3.fromRGB(80, 140, 240),
		AccentGold = Color3.fromRGB(240, 200, 80),
		AccentRed = Color3.fromRGB(200, 80, 80),
		AccentPurple = Color3.fromRGB(140, 100, 200),
		AccentPink = Color3.fromRGB(255, 120, 200),
		AccentTeal = Color3.fromRGB(60, 180, 200),

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

return Theme
