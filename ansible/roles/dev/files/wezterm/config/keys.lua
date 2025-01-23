local wezterm = require('wezterm') --[[@as Wezterm]]
local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')

local act = wezterm.action
local utils = require('utils')

local keys = {
    {
        key = ',',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab({
            cwd = wezterm.home_dir .. '/.config/wezterm/',
            args = {
                os.getenv('SHELL'),
                '-c',
                'nvim ' .. wezterm.home_dir .. '/.config/wezterm/wezterm.lua',
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
        mods = 'CMD',
        action = wezterm.action.SpawnCommandInNewTab({
            args = { os.getenv('SHELL'), '-c', 'lazygit' },
            label = 'lazygit',
        }),
    },
    {
        key = 'b',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab({
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
        mods = 'CTRL|SHIFT|CMD',
        action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT|CMD',
        action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },

    {
        key = 'h',
        mods = 'CTRL|SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Left', 1 }),
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Down', 1 }),
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Up', 1 }),
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Right', 1 }),
    },

    {
        key = 'h',
        mods = 'CTRL|CMD',
        action = act.ActivatePaneDirection('Left'),
    },
    {
        key = 'j',
        mods = 'CTRL|CMD',
        action = act.ActivatePaneDirection('Down'),
    },
    {
        key = 'k',
        mods = 'CTRL|CMD',
        action = act.ActivatePaneDirection('Up'),
    },
    {
        key = 'l',
        mods = 'CTRL|CMD',
        action = act.ActivatePaneDirection('Right'),
    },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    -- {
    --     key = 'a',
    --     mods = 'LEADER|CTRL',
    --     action = act.SendKey({ key = 'a', mods = 'CTRL' }),
    -- },
}

local config = {
    disable_default_key_bindings = false,
    -- leader = { key = 'a', mods = 'CTRL' },
    keys = keys,
}

return config
