vim.lsp.enable('basedpyright')

return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'python', 'ninja', 'rst' } },
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
