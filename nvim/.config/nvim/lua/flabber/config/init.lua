-- plugins are managed with lazy.nvim
-- so we only require the nvim basics here
-- the rest is enabled in the lazy.lua module
require("flabber.config.options")
require("flabber.config.lazy")
require("flabber.config.keymaps")
require("flabber.config.autocmds")
