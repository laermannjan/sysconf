return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "http", "json" })
      end
    end,
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- keys = {
    --   -- { "<leader>rr", "<Plug>(RestNvim)", mode = { "n", "v" } },
    -- },
    config = function(_, opts)
      vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim")
      require("rest-nvim").setup(opts)
    end,
  },
}
