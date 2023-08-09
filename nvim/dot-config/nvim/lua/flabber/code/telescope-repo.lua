return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "cljoly/telescope-repo.nvim",
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
    keys = {
        { "<leader>fr", "<cmd>Telescope repo list<cr>", "Find repos" },
    },
}
