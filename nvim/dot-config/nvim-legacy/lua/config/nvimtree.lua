local status_ok, nvimtree = pcall(require, "nvim-tree")
local utils = require("utils")
if not status_ok then
   utils.warn("nvim-tree could not be required", "nvim-tree-config")
   return
end

nvimtree.setup()
