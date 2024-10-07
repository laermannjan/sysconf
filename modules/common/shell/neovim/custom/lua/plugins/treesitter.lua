local M = {
   "nvim-treesitter/nvim-treesitter",
   -- event = { "BufReadPost", "BufNewFile" },
   build = ":TSUpdate",

   dependencies = {
      {
         "nvim-treesitter/nvim-treesitter-textobjects",
         -- event = "VeryLazy",
      },
   },
}

M.config = function()
   require("nvim-treesitter.configs").setup {
      ensure_installed = {
         "c",
         "cpp",
         "go",
         "lua",
         "python",
         "rust",
         "nix",
         "tsx",
         "javascript",
         "typescript",
         "vimdoc",
         "vim",
         "bash",
         "markdown",
      },

      auto_install = true,
      ignore_install = {},
      sync_install = false,
      modules = {},

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
      	enable = true,
      	keymaps = {
      		init_selection = "<c-space>",
      		node_incremental = "<c-space>",
      		node_decremental = "<c-h>",  -- NOTE: <c-h> same as <c-backspace> in temrinal
      	},
      },
   }
end

return M
