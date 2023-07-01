return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      mode = "topline",
    },
  },

  {
    "IndianBoy42/tree-sitter-just",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    setup = function()
      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
      require("IndianBoy42/tree-sitter-just").setup()
    end,
  },
}
