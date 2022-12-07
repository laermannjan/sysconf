local M = {}

function M.setup()
   require("toggleterm").setup {
      open_mapping = [[<C-\>]],
   }
end

return M
