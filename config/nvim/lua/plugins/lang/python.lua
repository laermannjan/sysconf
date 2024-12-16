return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'python', 'ninja', 'rst' } },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            servers = {
                ruff = {
                    init_options = {
                        settings = {
                            fixAll = true,
                            organizeImports = true,
                            showSyntaxErrors = true,
                        },
                    },
                    on_attach = function(client, bufnr)
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end,
                },
                pyright = {
                    enabled = false,
                    settings = {
                        pyright = {
                            -- Using Ruff's import organizer
                            disableOrganizeImports = true,
                        },
                        python = {
                            analysis = {
                                autoImportCompletions = true,
                                typeCheckingMode = 'off',
                                -- ignore = { "*" },
                            },
                        },
                    },
                },
                basedpyright = {
                    before_init = function(_, c)
                        if not c.settings then c.settings = {} end
                        if not c.settings.python then c.settings.python = {} end
                        c.settings.python.pythonPath = vim.fn.exepath('python')
                    end,
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = 'basic',
                                autoImportCompletions = true,
                                -- stubPath = vim.env.HOME .. '/typings',
                                diagnosticSeverityOverrides = {
                                    reportUnusedImport = 'information',
                                    reportUnusedFunction = 'information',
                                    reportUnusedVariable = 'information',
                                    reportGeneralTypeIssues = 'none',
                                    reportOptionalMemberAccess = 'none',
                                    reportOptionalSubscript = 'none',
                                    reportPrivateImportUsage = 'none',
                                },
                            },
                        },
                    },
                },
            },
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
