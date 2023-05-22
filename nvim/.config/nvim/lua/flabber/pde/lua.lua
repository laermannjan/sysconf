if not vim.g.flabber.pde.lua then
    return {}
end

return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luau", "luap" })
        end,
    },
    {
        "mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "lua_ls" })
        end,
    },
    {
        "null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            vim.list_extend(opts.sources, { nls.builtins.formatting.stylua })
        end,
    },
}
