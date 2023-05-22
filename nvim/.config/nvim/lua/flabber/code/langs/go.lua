return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "go", "gomod" })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.lsp.ensure_installed, { "gopls" })

            local null_ls = require("null-ls")
            vim.list_extend(opts.null_ls.sources, {
                null_ls.builtins.formatting.gofumpt,
                null_ls.builtins.formatting.goimports_reviser,
                null_ls.builtins.formatting.golines,
            })
        end,
    },
}
