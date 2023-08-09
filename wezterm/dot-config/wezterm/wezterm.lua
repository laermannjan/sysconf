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

-- config.color_scheme = "tokyonight_night"
-- config.color_scheme = "Gotham (Gogh)"
-- config.color_scheme = "SeaShells"
config.font = wezterm.font("ComicCode Nerd Font")

config.font_size = 16.0
config.line_height = 1.0

config.use_dead_keys = false
config.scrollback_lines = 10000

config.enable_tab_bar = false
config.use_fancy_tab_bar = false

config.colors = {
	background = "rgb(18 24 27)", -- black
	foreground = "rgb(228 228 231)", --white

	-- tailwind colors.. search for `text-{color}-600` for normal or `text-{color}-400/300` for bright
	ansi = {
		"rgb(18 24 27)", -- black
		"rgb(239 68 68)", -- red
		"rgb(34 197 94)", -- green
		"rgb(245 158 11)", --yellow
		"rgb(37 99 235)", -- blue
		"rgb(147 51 234)", -- magenta
		"rgb(8 145 178)", -- cyan
		"rgb(209 213 219)", --white
	},

	brights = {
		"rgb(108 121 131)",
		"rgb(248 113 113)",
		"rgb(74 222 128)",
		"rgb(253 186 116)",
		"rgb(96 165 250)",
		"rgb(192 132 252)",
		"rgb(34 211 238)",
		"rgb(243 244 246)",
	},
}

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
		key = "G",
		mods = "CTRL|SHIFT",
		action = act.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				if not id and not label then
					wezterm.log_info("cancelled")
				else
					wezterm.log_info("you selected ", id, label)
					pane:send_text(id)
				end
			end),
			title = "I am title",
			choices = {
				-- This is the first entry
				{
					-- Here we're using wezterm.format to color the text.
					-- You can just use a string directly if you don't want
					-- to control the colors
					label = wezterm.format({
						{ Foreground = { AnsiColor = "Red" } },
						{ Text = "No" },
						{ Foreground = { AnsiColor = "Green" } },
						{ Text = " thanks" },
					}),
					-- This is the text that we'll send to the terminal when
					-- this entry is selected
					id = "Regretfully, I decline this offer.",
				},
				-- This is the second entry
				{
					label = "WTF?",
					id = "An interesting idea, but I have some questions about it.",
				},
				-- This is the third entry
				{
					label = "LGTM",
					id = "This sounds like the right choice",
				},
			},
		}),
	},

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
