return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'zig' } },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            servers = {
                zls = {},
            },
        },
    },
    {
        'nvim-neotest/neotest',
        optional = true,
        dependencies = {
            'lawrence-laz/neotest-zig',
        },
        opts = {
            adapters = {
                ['neotest-zig'] = {},
            },
        },
    },
}
