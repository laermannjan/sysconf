local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local set_environemnt_variables = function()
	local paths = {
		wezterm.home_dir .. "/.cargo/bin",
		"/opt/homebrew/bin",
	}

	return {
		PATH = table.concat(paths, ":") .. ":" .. os.getenv("PATH"),
	}
end

-- events
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("update-status", function(window, pane)
	window:set_left_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { AnsiColor = "Blue" } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.set_environment_variables = set_environemnt_variables()

config.leader = { key = "Space", mods = "CTRL|SHIFT" }

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
config.font = wezterm.font("JetBrains Mono Light")
config.font = wezterm.font("Monaspace Argon Var")
config.font = wezterm.font("Monaspace Xenon Var")
config.font = wezterm.font("Monaspace Radon")
-- config.font = wezterm.font("Monaspace Krypton")

config.font_size = 16.0
config.line_height = 1.0

config.use_dead_keys = false
config.scrollback_lines = 10000

config.enable_tab_bar = true
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

-- config.window_decorations = "RESIZE"
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

local function toggle_zoom_or_split(window, pane)
	local panes = window:active_tab():panes()

	if #panes == 1 then
		window:perform_action(wezterm.action({ SplitPane = { direction = "Down", size = { Percent = 25 } } }), pane)
	else
		window:perform_action(act.ActivatePaneByIndex(panes[1]:pane_id()), pane)
		window:perform_action("TogglePaneZoomState", pane)
	end
	-- wezterm:perform_action(wezterm.action.SplitPane({ size = { Percent = 20 }, direction = "Down" }), pane)
	-- -- Check if the current pane is the only pane in the window
	-- if #window:panes() == 1 then
	-- 	-- Split the current pane horizontally if it's the only one
	-- 	window:perform_action(wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }), pane)
	-- else
	-- 	-- Otherwise, toggle the zoom state of the pane
	-- 	window:perform_action("TogglePaneZoomState", pane)
	-- end
end
wezterm.on("toggle_zoom_or_split", toggle_zoom_or_split)

config.keys = {
	{
		key = "\\",
		mods = "CTRL",
		action = act.EmitEvent("toggle_zoom_or_split"),
	},
	{
		key = "w",
		mods = "CMD",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "h",
		mods = "CMD",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		key = "h",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "j",
		mods = "CMD",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "j",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "CMD",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "l",
		mods = "CMD",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "l",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "l",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "z",
		mods = "CMD|SHIFT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "g",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "/opt/homebrew/bin/fish", "-c", "/opt/homebrew/bin/lazygit" },
		}),
	},
	{
		key = "b",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "btop" },
		}),
	},
	{
		key = "f",
		mods = "CMD|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			-- Here you can dynamically construct a longer list if needed

			local cmd = [[{
			/opt/homebrew/bin/fd --type directory --exact-depth 1 . ~/code/{alcemy,lj}
			/opt/homebrew/bin/fd --type directory --exact-depth 3 . ~/code/lj/dotfiles
			}]]
			local _, code_dirs, _ = wezterm.run_child_process({ "bash", "-c", cmd })

			local workspaces = { { id = wezterm.home_dir .. "/Downloads/", label = wezterm.home_dir .. "/Downloads/" } }
			for dir in code_dirs:gmatch("[^\r\n]+") do
				table.insert(workspaces, { id = dir, label = dir:match(".*/(.*/.*)/$") })
			end

			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							wezterm.log_info("id = " .. id)
							wezterm.log_info("label = " .. label)
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										cwd = id,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
					fuzzy_description = ">",
				}),
				pane
			)
		end),
	},
}

return config
