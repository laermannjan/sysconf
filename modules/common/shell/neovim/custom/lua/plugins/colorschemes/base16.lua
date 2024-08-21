local M = {
   "tinted-theming/base16-vim",
   -- "RRethy/base16-nvim",
   lazy = false,
   priority = 1000,
   opts = {
      --
   },
}

M.config = function(_, opts)
   if string.match(vim.g.colorscheme, "^base16-") then
      -- require("base16-colorscheme").with_config {
      --    telescope = true,
      --    indentblankline = true,
      --    notify = true,
      --    ts_rainbow = true,
      --    cmp = true,
      --    illuminate = true,
      --    dapui = true,
      -- }
      vim.cmd.colorscheme(vim.g.colorscheme)
      -- You can get the base16 colors **after** setting the colorscheme by name (base01, base02, etc.)
      -- local color = require("base16-colorscheme").colors.base01
   end
end

return M
