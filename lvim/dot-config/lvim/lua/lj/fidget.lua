-- a little info at the bottom showing LSP progress when initializing

table.insert(lvim.plugins, "j-hui/fidget.nvim")
local fidget = reload "fidget"

fidget.setup()
