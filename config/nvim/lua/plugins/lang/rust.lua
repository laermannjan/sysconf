return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'rust', 'toml', 'ron' } },
    },

    { 'williamboman/mason.nvim', opts = { ensure_installed = { 'codelldb' } } },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            servers = {
                ['rust_analyzer'] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        buildScripts = {
                            enable = true,
                        },
                    },
                    checkOnSave = true,
                    diagnostics = {
                        enable = true,
                    },
                    procMacro = {
                        enable = true,
                        ignored = {
                            ['async-trait'] = { 'async_trait' },
                            ['napi-derive'] = { 'napi' },
                            ['async-recursion'] = { 'async_recursion' },
                        },
                    },
                    files = {
                        excludeDirs = {
                            '.direnv',
                            '.git',
                            '.github',
                            '.gitlab',
                            'bin',
                            'node_modules',
                            'target',
                            'venv',
                            '.venv',
                        },
                    },
                },
            },
        },
    },
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
