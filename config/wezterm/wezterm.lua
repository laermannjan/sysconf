local wezterm = require('wezterm')
local act = wezterm.action

local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')

-- 0. HELPERS ==========================================================================================================

local function get_os()
    local triple = wezterm.target_triple
    if string.find(triple, 'windows') then
        return 'windows'
    elseif string.find(triple, 'linux') then
        return 'linux'
    elseif string.find(triple, 'apple') then
        return 'mac'
    else
        return 'unknown'
    end
end

local config = wezterm.config_builder()

-- 1. SETTINGS =========================================================================================================

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.default_prog = get_os() == 'windows' and { 'pwsh.exe' } or nil
config.default_workspace = '~'
config.use_dead_keys = false
config.scrollback_lines = 10000

config.animation_fps = 120
config.max_fps = 120
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

config.colors = {
    background = '#121b1b', -- black
    foreground = '#e4e4e7', --white
    -- tailwind colors.. search for `text-{color}-600` for normal or `text-{color}-400/300` for bright
    ansi = {
        '#121b1b', -- black
        '#ef4444', -- red
        '#22c55e', -- green
        '#f59e0b', --yellow
        '#2563eb', -- blue
        '#9333ea', -- magenta
        '#0891b2', -- cyan
        '#d1d5db', --white
    },
    brights = {
        '#6c7983',
        '#f87171',
        '#4ade80',
        '#fdba74',
        '#60a5fa',
        '#c084fc',
        '#22d3ee',
        '#f3f4f6',
    },
}

config.enable_scroll_bar = true

-- tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_and_split_indices_are_zero_based = false

-- window
config.window_padding = { left = 5, right = 10, top = 12, bottom = 7 }
config.window_close_confirmation = 'NeverPrompt'
-- NOTE: why do I need to put these font settings into window_frame?
config.window_frame = {
    active_titlebar_bg = '#090909',
    font = wezterm.font({ family = 'Berkley Mono', weight = 'Bold' }),
    font_size = os == 'mac' and 16.0 or 13.0,
}
-- config.window_decorations = "RESIZE"
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.65 }

-- fonts
config.adjust_window_size_when_changing_font_size = false
config.allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace'
config.anti_alias_custom_block_glyphs = true
config.font_size = os == 'mac' and 16.0 or 13.0
config.font = wezterm.font('ComicCode Nerd Font')
-- config.font = wezterm.font 'JetBrains Mono Light'
-- config.font = wezterm.font 'Monaspace Argon Var'
-- config.font = wezterm.font 'Monaspace Xenon Var'
-- config.font = wezterm.font 'MonaspiceRn Nerd Font'
-- config.font = wezterm.font 'Monaspace Krypton'

function workspaces()
    local active = wezterm.mux.get_active_workspace()
    local workspaces = wezterm.mux.get_workspace_names()

    local ws = {}

    for i, val in ipairs(workspaces) do
        local workspace_str = i .. ': ' .. val
        if active == val then
            table.insert(ws, {
                label = '[' .. workspace_str .. ']',
                active = true,
            })
        else
            table.insert(ws, {
                label = ' ' .. workspace_str .. ' ',
                active = false,
            })
        end
    end

    return ws
end

wezterm.on('update-status', function(window, _)
    local segments = worspaces()

    local color_scheme = window:effective_config()
    local active_color = wezterm.color.parse(color_scheme.window_frame.button_fg)
    local inactive_color = active_color:darken(0.3)

    -- We'll build up the elements to send to wezterm.format in this table.
    local elements = {}

    for _, seg in ipairs(segments) do
        if seg.active then
            table.insert(elements, { Foreground = { Color = active_color } })
        else
            table.insert(elements, { Foreground = { Color = inactive_color } })
        end
        table.insert(elements, { Background = { Color = 'none' } })
        table.insert(elements, { Text = seg.label })
    end

    table.insert(elements, { Text = ' ' }) -- a bit of padding

    window:set_right_status(wezterm.format(elements))
end)

-- 2. KEYBINGS =========================================================================================================

local function spawn_in_tab(cmd) return act.SpawnCommandInNewTab({ args = { os.getenv('SHELL') or 'powershell.exe', '-lic', cmd } }) end

local function k(mac, other) return get_os() == 'mac' and mac or other end

config.keys = {
    { mods = k('CMD', 'ALT'), key = ',', action = spawn_in_tab('nvim ' .. wezterm.config_file) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = ',', action = act.ReloadConfiguration },

    { mods = k('CMD', 'ALT'), key = '1', action = act.ActivateTab(0) },
    { mods = k('CMD', 'ALT'), key = '2', action = act.ActivateTab(1) },
    { mods = k('CMD', 'ALT'), key = '3', action = act.ActivateTab(2) },
    { mods = k('CMD', 'ALT'), key = '4', action = act.ActivateTab(3) },
    { mods = k('CMD', 'ALT'), key = '5', action = act.ActivateTab(4) },
    { mods = k('CMD', 'ALT'), key = '6', action = act.ActivateTab(5) },
    { mods = k('CMD', 'ALT'), key = '7', action = act.ActivateTab(6) },
    { mods = k('CMD', 'ALT'), key = '8', action = act.ActivateTab(7) },
    { mods = k('CMD', 'ALT'), key = '9', action = act.ActivateTab(-1) },

    { mods = k('CMD', 'ALT'), key = 't', action = act.SpawnTab('CurrentPaneDomain') },

    { mods = k('CMD', 'ALT'), key = 'w', action = act.CloseCurrentPane({ confirm = true }) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'w', action = act.CloseCurrentTab({ confirm = true }) },

    { mods = k('CMD', 'ALT'), key = 'd', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'd', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

    { mods = k('CMD|OPT', 'ALT|WIN'), key = 'i', action = act.ShowDebugOverlay },

    { mods = k('CMD', 'ALT'), key = 'g', action = spawn_in_tab('lazygit'), label = 'lazygit' },

    { mods = 'SHIFT', key = 'Tab', action = workspace_switcher.switch_workspace() },

    { mods = k('CMD', 'ALT'), key = 'Enter', action = act.TogglePaneZoomState },

    { mods = k('CMD', 'ALT'), key = 'h', action = act.ActivatePaneDirection('Left') },
    { mods = k('CMD', 'ALT'), key = 'j', action = act.ActivatePaneDirection('Down') },
    { mods = k('CMD', 'ALT'), key = 'k', action = act.ActivatePaneDirection('Up') },
    { mods = k('CMD', 'ALT'), key = 'l', action = act.ActivatePaneDirection('Right') },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'h', action = act.AdjustPaneSize({ 'Left', 3 }) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
    { mods = k('CMD|SHIFT', 'ALT|SHIFT'), key = 'l', action = act.AdjustPaneSize({ 'Right', 3 }) },
}

return config
