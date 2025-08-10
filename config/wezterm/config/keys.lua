local wezterm = require('wezterm') --[[@as Wezterm]]
local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')

local act = wezterm.action
local utils = require('utils')

local keys = {
    {
        key = ',',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab({
            args = {
                os.getenv('SHELL'), -- should be fish
                '-l',
                '-i',
                '-c',
                'nvim ' .. wezterm.shell_quote_arg(wezterm.config_file),
            },
        }),
    },
    {
        key = ',',
        mods = 'CMD|SHIFT',
        action = act.ReloadConfiguration,
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
        key = 'd',
        mods = 'CMD|SHIFT',
        action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = 'd',
        mods = 'CMD',
        action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },

    { key = 'i', mods = 'CMD|OPT', action = act.ShowDebugOverlay },

    {
        key = 'Enter',
        mods = 'CMD',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'g',
        mods = 'CMD',
        action = wezterm.action.SpawnCommandInNewTab({
            args = { os.getenv('SHELL'), '-lic', 'lazygit' },
            label = 'lazygit',
        }),
    },
    {
        key = 'b',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab({
            args = { os.getenv('SHELL'), '-lic', 'btop' },
        }),
    },
    {
        key = 'Tab',
        mods = 'SHIFT',
        action = workspace_switcher.switch_workspace(),
    },

    {
        key = 'h',
        mods = 'SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Left', 3 }),
    },
    {
        key = 'j',
        mods = 'SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Down', 1 }),
    },
    {
        key = 'k',
        mods = 'SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Up', 1 }),
    },
    {
        key = 'l',
        mods = 'SHIFT|CMD',
        action = act.AdjustPaneSize({ 'Right', 3 }),
    },

    {
        key = 'h',
        mods = 'CMD',
        action = act.ActivatePaneDirection('Left'),
    },
    {
        key = 'j',
        mods = 'CMD',
        action = act.ActivatePaneDirection('Down'),
    },
    {
        key = 'k',
        mods = 'CMD',
        action = act.ActivatePaneDirection('Up'),
    },
    {
        key = 'l',
        mods = 'CMD',
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
