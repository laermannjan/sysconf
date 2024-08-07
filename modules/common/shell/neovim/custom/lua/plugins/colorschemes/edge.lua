local M = {
   "sainnhe/edge",
   lazy = false,
   priority = 1000,
   opts = {
      --
   },
}

M.config = function(_, opts)
   if vim.tbl_contains({ "edge" }, vim.g.colorscheme) then
      require("edge").setup(opts)
      vim.cmd.colorscheme(vim.g.colorscheme)
   end
end

return M
