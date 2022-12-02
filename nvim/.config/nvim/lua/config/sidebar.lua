local M = {}

M.setup = function()
   local ok, sidebar = pcall(require, "sidebar-nvim")
   if not ok then
      require("utils").warn("could not require 'sidebar-nvim", "sidebar-nvim config")
      return
   end

   sidebar.setup {
      side = "right",
      sections = { "symbols", "diagnostics", "files" },
      files = {
         show_hidden = true
      },
   }
end

return M
