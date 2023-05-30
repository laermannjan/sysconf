if not vim.g.flabber.pde.go then
    return {}
end

-- Vim test
vim.g["test#go#runner"] = "delve"

return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "go", "gomod" })
        end,
    },
    {
        "mason-lspconfig.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "gopls" })
        end,
    },
    {
        "null-ls.nvim",
        opts = function(_, opts)
            local null_ls = require("null-ls")
            vim.list_extend(opts.sources, {
                null_ls.builtins.formatting.gofumpt,
                null_ls.builtins.formatting.goimports_reviser,
                null_ls.builtins.formatting.golines,
            })
        end,
    },
}
