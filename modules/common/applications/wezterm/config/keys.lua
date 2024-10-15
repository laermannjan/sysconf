local wezterm = require('wezterm')
local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')
local act = wezterm.action
local utils = require('utils')

local keys = {
    {
        key = ',',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab({
            cwd = wezterm.home_dir .. '/dev/lj/system-config',
            args = {
                os.getenv('SHELL'),
                '-c',
                'nvim ' .. wezterm.home_dir .. '/dev/lj/system-config',
            },
        }),
    },
    {
        key = 'w',
        mods = 'CMD',
        action = act.CloseCurrentPane({ confirm = true }),
    },
    {
        key = 'w',
        mods = 'CMD|SHIFT',
        action = act.CloseCurrentTab({ confirm = true }),
    },
    {
        key = 'Enter',
        mods = 'CMD',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'g',
        mods = 'LEADER',
        action = wezterm.action.SpawnCommandInNewTab({
            args = { os.getenv('SHELL'), '-c', 'lazygit' },
            label = 'lazygit',
        }),
    },
    {
        key = 'b',
        mods = 'LEADER',
        action = wezterm.action.SpawnCommandInNewTab({
            args = { os.getenv('SHELL'), '-c', 'btop' },
        }),
    },
    {
        key = '`',
        mods = 'CMD',
        action = workspace_switcher.switch_workspace(),
    },

    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = 's',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = 'v',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = 'a',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }),
    },
}

local config = {
    disable_default_key_bindings = false,
    leader = { key = 'a', mods = 'CTRL' },
    keys = keys,
}

return config
