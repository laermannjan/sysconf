local wezterm = require('wezterm') --[[@as Wezterm]]
local domains = wezterm.plugin.require('https://github.com/DavidRR-F/quick_domains.wezterm')

require('events.gui-startup').setup()
require('events.update-status').setup()

local config = require('utils.config'):new()
config:add('config.appearance')
config:add('config.keys')
config:add('config.fonts')
config:add('config.general')

domains.apply_to_config(config, {
    keys = {
        attach = { key = '`', mods = 'CMD|CTRL' },
        vsplit = { key = '`', mods = 'CMD|SHIFT|CTRL' },
        hsplit = { key = '~', mods = 'CMD|CTRL|SHIFT' },
    },
    auto = {
        ssh_ignore = true,
        exec_ignore = {
            ssh = false,
            docker = false,
            kubernetes = true,
        },
    },
})

return config
