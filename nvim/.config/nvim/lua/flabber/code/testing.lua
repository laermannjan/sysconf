local vim_test_spec = {
    "vim-test/vim-test",
    keys = {
        { "<leader>tc", "<cmd>TestClass<cr>", desc = "Class" },
        { "<leader>tf", "<cmd>TestFile<cr>", desc = "File" },
        { "<leader>tl", "<cmd>TestLast<cr>", desc = "Last" },
        { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Nearest" },
        { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Suite" },
        { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Visit" },
    },
    config = function()
        -- vim.g["test#strategy"] = "neovim"
        vim.g["test#strategy"] = "toggleterm"
        -- vim.g["test#strategy"] = "kitty"
        -- vim.g["test#neovim#term_position"] = "belowright"
        -- vim.g["test#neovim#preserve_screen"] = 1
    end,
}
local neotest_spec = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
    },
    opts = { adapters = {} },
    config = function(_, opts)
        require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
        {
            "<leader>tn",
            function() require("neotest").run.run() end,
            desc =
            "Run Nearest"
        },
        {
            "<leader>tf",
            function() require("neotest").run.run(vim.fn.expand("%")) end,
            desc =
            "Run File"
        },
        {
            "<leader>ts",
            function() require("neotest").summary.toggle() end,
            desc =
            "Toggle Summary"
        },
        {
            "<leader>to",
            function() require("neotest").output.open({ enter = true, auto_close = true }) end,
            desc =
            "Show Output"
        },
        {
            "<leader>tO",
            function() require("neotest").output_panel.toggle() end,
            desc =
            "Toggle Output Panel"
        },
        {
            "<leader>tx",
            function() require("neotest").run.stop() end,
            desc =
            "Stop"
        },
    },
}

if vim.g.flabber.testing.neotest then
    return neotest_spec
else
    return vim_test_spec
end
