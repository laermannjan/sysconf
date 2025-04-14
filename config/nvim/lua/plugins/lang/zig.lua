vim.lsp.enable('zls')

return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'zig' } },
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
