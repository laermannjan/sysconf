return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luau", "luap" })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.lsp.ensure_installed, { "lua_ls" })

            local nls = require("null-ls")
            vim.list_extend(opts.null_ls.sources, { nls.builtins.formatting.stylua })
        end,
    },
}
