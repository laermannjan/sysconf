table.insert(lvim.plugins, "aserowy/tmux.nvim")
local tmux = require("tmux")
tmux.setup()
print("tmux setup")
