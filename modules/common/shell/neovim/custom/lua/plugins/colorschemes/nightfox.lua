local M = {
   "EdenEast/nightfox.nvim",
   lazy = false,
   priority = 1000,
   opts = {
      --
   },
}

M.config = function(_, opts)
   if vim.tbl_contains({ "nightfox", "duskfox", "terafox" }, vim.g.colorscheme) then
      require("nightfox").setup(opts)
      vim.cmd.colorscheme(vim.g.colorscheme)
   end
end

return M
