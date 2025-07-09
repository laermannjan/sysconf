return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'python', 'ninja', 'rst' } },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = { 'basedpyright', 'pyright' },
            automatic_enable = { exclude = { 'pyright' } },
        },
    },
    {
        'nvim-neotest/neotest',
        optional = true,
        dependencies = {
            'nvim-neotest/neotest-python',
        },
        opts = {
            adapters = {
                ['neotest-python'] = {
                    -- Here you can specify the settings for the adapter, i.e.
                    -- runner = "pytest",
                    -- python = ".venv/bin/python",
                },
            },
        },
    },
}
