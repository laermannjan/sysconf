local wezterm = require("wezterm")
local platform = require("utils.platform")

return {
	adjust_window_size_when_changing_font_size = false,
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	anti_alias_custom_block_glyphs = true,

	font_rules = {
		{
			intensity = "Normal",
			italic = true,
			font = wezterm.font_with_fallback({
				{
					family = "MonaspiceRn Nerd Font",
					style = "Normal",
					weight = "Regular",
					stretch = "Expanded",
					harfbuzz_features = { "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
				},
				{ family = "Symbols Nerd Font" },
			}),
		},
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font_with_fallback({
				{
					family = "MonaspiceKr Nerd Font",
					style = "Italic",
					weight = "Black",
					harfbuzz_features = { "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
					scale = 1.1,
				},
				{ family = "Symbols Nerd Font" },
			}),
		},
	},

	-- font = wezterm.font("ComicCode Nerd Font"),
	-- font = wezterm.font("JetBrains Mono Light"),
	-- font = wezterm.font("Monaspace Argon Var"),
	-- font = wezterm.font("Monaspace Xenon Var"),
	-- font = wezterm.font("MonaspiceRn Nerd Font"),
	-- font = wezterm.font("Monaspace Krypton"),

	font_size = platform().is_mac and 16.0 or 13.0,
	-- window_frame = {
	-- 	font = wezterm.font({ family = "Menlo", weight = "Bold" }),
	-- },
}
