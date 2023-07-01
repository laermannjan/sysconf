return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "cljoly/telescope-repo.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  keys = {
    { "<leader>fr", "<cmd>Telescope repo list<cr>", "Find repos" },
  },
  opts = {
    extensions = {
      repo = {
        list = {
          search_dirs = {
            "~/code/alcemy/",
            "~/code/lj/",
          },
        },
        settings = {
          auto_lcd = true,
        },
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("repo")
    require("telescope").load_extension("fzy_native")
  end,
}
