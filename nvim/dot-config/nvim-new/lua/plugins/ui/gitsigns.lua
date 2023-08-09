return {
    {
        "lewis6991/gitsigns.nvim",
        enabled = vim.fn.executable("git") == 1,
        event = { "BufReadPre", "BufNewFile" },
        after = { "VonHeikemen/lsp-zero.nvim" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▎" },
                topdelete = { text = "󰐊" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
            local ok, null_ls = pcall(require, "null-ls")
            if ok then
                null_ls.register(null_ls.builtins.code_actions.gitsigns)
            end
        end,
    },
}
