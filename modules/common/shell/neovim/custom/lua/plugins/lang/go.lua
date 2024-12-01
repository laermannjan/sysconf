return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'go', 'gomod', 'gowork', 'gosum' } },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = { 'goimports', 'gofumpt' },
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            gofumpt = true,
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            analyses = {
                                fieldalignment = true,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
                            semanticTokens = true,
                        },
                    },
                },
            },
        },
    },
    {
        'stevearc/conform.nvim',
        optional = true,
        opts = {
            formatters_by_ft = {
                go = { 'goimports', 'gofumpt' },
            },
        },
    },
    {
        'mfussenegger/nvim-dap',
        optional = true,
        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = { ensure_installed = { 'delve' } },
            },
            {
                'leoluz/nvim-dap-go',
                opts = {},
            },
        },
    },
    {
        'nvim-neotest/neotest',
        optional = true,
        dependencies = {
            'fredrikaverpil/neotest-golang',
        },
        opts = {
            adapters = {
                ['neotest-golang'] = {
                    -- Here we can set options for neotest-golang, e.g.
                    -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
                    dap_go_enabled = true, -- requires leoluz/nvim-dap-go
                },
            },
        },
    },

    -- Filetype icons
    {
        'echasnovski/mini.icons',
        opts = {
            file = {
                ['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
            },
            filetype = {
                gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
            },
        },
    },
}
