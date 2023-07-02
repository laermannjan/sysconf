local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action

-- events
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.5,
}

config.front_end = "WebGpu"
config.max_fps = 240

config.color_scheme = "tokyonight_night"
-- config.color_scheme = "Gotham (Gogh)"
-- config.color_scheme = "SeaShells"
config.font = wezterm.font("ComicCode Nerd Font")

config.font_size = 16.0
config.line_height = 1.0

config.use_dead_keys = false
config.scrollback_lines = 10000

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.95
-- config.macos_window_background_blur = 20
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_frame = {
	font = wezterm.font({ family = "Menlo", weight = "Bold" }),
}

config.keys = {
	{
		key = "E",
		mods = "CMD",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "Enter",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = "N",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "E",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for workspace",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
}

return config
