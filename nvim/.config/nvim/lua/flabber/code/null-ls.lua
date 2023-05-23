return {
    "jay-babu/mason-null-ls.nvim",
    opts = {
        ensure_installed = nil,
        automatic_installation = true,
    },
    dependencies = {
        "williamboman/mason.nvim",
        {
            "jose-elias-alvarez/null-ls.nvim",
            opts = { sources = {} },
            dependencies = {
                "VonHeikemen/lsp-zero.nvim", -- setup must run after lsp-zero's lsp.setup()
            },
        },
    },
}
