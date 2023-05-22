return {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
        require("oil").setup(opts)
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end,
}
