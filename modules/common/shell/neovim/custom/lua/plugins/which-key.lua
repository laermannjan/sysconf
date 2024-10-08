local M = {
   "folke/which-key.nvim",
   opts = {
        preset = "helix",
        sort = {"alphanum"},
    },
   keys = {
      { "<leader>f", group = "file" },
      { "<leader>g", group = "git" },
      { "<leader>u", group = "(ui) toggles" },
      { "<leader>c", group = "code" },
      { "<leader>t", group = "test" },
   },
}

return M
