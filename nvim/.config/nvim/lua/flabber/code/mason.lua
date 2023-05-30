return {
    {
        "williamboman/mason.nvim",
        build = function()
            pcall(vim.cmd, "MasonUpdate")
        end,
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim"
        },
        opts = {
            ensure_installed = {}, -- to be overriden in pde modules
        },
    },
}
