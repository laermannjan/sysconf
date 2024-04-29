require("events.gui-startup").setup()
require("events.update-status").setup()

local config = require("utils.config"):new()
config:add("config.appearance")
config:add("config.keys")
config:add("config.fonts")
config:add("config.general")

return config
