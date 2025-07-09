return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'rust', 'toml', 'ron' } },
    },

    { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = { 'rust_analyzer', 'codelldb' } } },
    {
        'Saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
}
