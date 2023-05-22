return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "beancount" })
        end,
    },
    {
        "mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "beancount" })
        end,
    },
    {
        "null-ls.nvim",
        opts = function(_, opts)
            local null_ls = require("null-ls")
            vim.list_extend(opts.sources, { null_ls.builtins.formatting.bean_format })
        end,
    },
}
