local wezterm = require("wezterm")
local colors = require("colors")

return {
	animation_fps = 120,
	max_fps = 120,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",

	-- color scheme
	color_schemes = colors,
	-- color_scheme = "tokyonight_night"
	-- color_scheme = "Gotham (Gogh)"
	-- color_scheme = "SeaShells"
	color_scheme = "flabber",

	-- scrollbar
	enable_scroll_bar = true,

	-- tab bar
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 25,
	show_tab_index_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = true,
	tab_and_split_indices_are_zero_based = false,

	-- window
	window_padding = {
		left = 5,
		right = 10,
		top = 12,
		bottom = 7,
	},
	window_close_confirmation = "NeverPrompt",
	window_frame = {
		active_titlebar_bg = "#090909",
		-- font = fonts.font,
		-- font_size = fonts.font_size,
	},
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.65,
	},
}
