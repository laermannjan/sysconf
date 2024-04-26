local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local act = wezterm.action
local utils = require("utils")

local keys = {
	-- {
	-- 	key = "\\",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		local panes = window:active_tab():panes()
	--
	-- 		if #panes == 1 then
	-- 			window:perform_action(
	-- 				wezterm.action({ SplitPane = { direction = "Down", size = { Percent = 25 } } }),
	-- 				pane
	-- 			)
	-- 			-- window:perform_action(act.ActivatePaneDirection({ "Down", 1 }))
	-- 		else
	-- 			wezterm.log_info("zoomed?", pane:is_zoomed())
	-- 			window:perform_action(act.ActivatePaneByIndex(panes[1]:pane_id()), pane)
	-- 			window:perform_action("TogglePaneZoomState", pane)
	-- 		end
	-- 	end),
	-- },
	-- Toggle zoom for neovim
	{
		key = "\\",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local tab = window:active_tab()

			-- Open pane below if current pane is vim
			if utils.is_vim(pane) then
				if (#tab:panes()) == 1 then
					-- Open pane below if when there is only one pane and it is vim
					pane:split({ direction = "Bottom", size = 0.25 })
				else
					-- Send `CTRL-; to vim`, navigate to bottom pane from vim
					tab:set_zoomed(false)
					window:perform_action({
						SendKey = { key = "\\", mods = "CTRL" },
					}, pane)
				end
			else
				-- Zoom to vim pane if it exists
				local vim_pane = utils.find_vim_pane(tab)
				if vim_pane then
					vim_pane:activate()
					tab:set_zoomed(true)
				end
			end
		end),
	},
	{
		key = ",",
		mods = "CMD",
		action = act.SpawnCommandInNewTab({
			cwd = wezterm.home_dir .. "/code/lj/system-config",
			args = {
				os.getenv("SHELL"),
				"-c",
				"nvim " .. wezterm.home_dir .. "/code/lj/system-config",
			},
		}),
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
		action = act.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		key = "j",
		mods = "CMD",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "CMD",
		action = act.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = "l",
		mods = "CMD",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "Enter",
		mods = "CTRL",
		action = act.TogglePaneZoomState,
	},
	{
		key = "g",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { os.getenv("SHELL"), "-c", "lazygit" },
			label = "lazygit",
		}),
	},
	{
		key = "b",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { os.getenv("SHELL"), "-c", "btop" },
		}),
	},
	{
		key = "s",
		mods = "CTRL",
		action = workspace_switcher.switch_workspace(),
	},
	-- {
	-- 	key = "f",
	-- 	mods = "CMD|SHIFT",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		-- Here you can dynamically construct a longer list if needed
	--
	-- 		local _, code_dirs, _ = wezterm.run_child_process({
	-- 			os.getenv("SHELL"),
	-- 			"-c",
	-- 			"fd --type directory --exact-depth 1 . ~/code/{alcemy,lj}",
	-- 		})
	--
	-- 		local workspaces = { { id = wezterm.home_dir .. "/Downloads/", label = wezterm.home_dir .. "/Downloads/" } }
	-- 		for dir in code_dirs:gmatch("[^\r\n]+") do
	-- 			table.insert(workspaces, { id = dir, label = dir:match(".*/(.*/.*)/$") })
	-- 		end
	--
	-- 		window:perform_action(
	-- 			act.InputSelector({
	-- 				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
	-- 					if not id and not label then
	-- 						wezterm.log_info("cancelled")
	-- 					else
	-- 						wezterm.log_info("id = " .. id)
	-- 						wezterm.log_info("label = " .. label)
	-- 						inner_window:perform_action(
	-- 							act.SwitchToWorkspace({
	-- 								name = label,
	-- 								spawn = {
	-- 									label = "Workspace: " .. label,
	-- 									cwd = id,
	-- 								},
	-- 							}),
	-- 							inner_pane
	-- 						)
	-- 					end
	-- 				end),
	-- 				title = "Choose Workspace",
	-- 				choices = workspaces,
	-- 				fuzzy = true,
	-- 				fuzzy_description = ">",
	-- 			}),
	-- 			pane
	-- 		)
	-- 	end),
	-- },
}

local config = {
	disable_default_key_bindings = false,
	leader = { key = "Space", mods = "CTRL|SHIFT" },
	keys = keys,
}

smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

return config
