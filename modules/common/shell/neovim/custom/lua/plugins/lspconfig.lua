return {
    {
        'saghen/blink.cmp',
        version = 'v0.*',
        dependencies = {
            { 'saghen/blink.compat', version = '*', opts = true },
            'rafamadriz/friendly-snippets',
            'crispgm/cmp-beancount',
            'giuxtaposition/blink-cmp-copilot',
            'zbirenbaum/copilot.lua',
            { 'kawre/neotab.nvim', opts = true },
        },
        opts = {
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'select_and_accept', 'snippet_forward', function(cmp) require('neotab').tabout() end, 'fallback' },
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
            },
            accept = { auto_brackets = { enabled = true } },
            trigger = { completion = { keyword_range = 'prefix' }, signature_help = { enabled = true } },
            windows = {
                autocomplete = { selection = 'manual' },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                ghost_text = { enabled = true },
            },
            sources = {
                -- add lazydev to your completion providers
                completion = {
                    enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'copilot' },
                },
                providers = {
                    -- dont show LuaLS require statements when lazydev has items
                    lsp = { fallback_for = { 'lazydev' } },
                    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
                    copilot = { name = 'copilot', module = 'blink-cmp-copilot' },
                    beancount = { name = 'beancount', module = 'blink.compat.source' },
                },
            },
        },
    },
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
        opts = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {
            servers = {
                lua_ls = {
                    handlers = {
                        -- Show only one definition to be usable with `a = function()` style.
                        -- Because LuaLS treats both `a` and `function()` as definitions of `a`.
                        ['textDocument/definition'] = function(err, result, ctx, config)
                            if type(result) == 'table' then result = { result[1] } end
                            vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
                        end,
                    },
                    settings = {
                        Lua = {
                            format = {
                                enable = false,
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
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
            },
        },
        config = function(_, opts)
            opts = opts or {}

            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            local has_blink, blink = pcall(require, 'blink.cmp')
            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {},
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend('force', {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if server_opts.enabled ~= false then require('lspconfig')[server].setup(server_opts) end
            end

            local ensure_installed = {}
            local handlers = { function(server) setup(server) end }
            for server, settings in pairs(servers) do
                if settings then
                    settings = settings == true and {} or settings
                    ensure_installed[#ensure_installed + 1] = server
                    handlers[server] = function() setup(server) end
                end
            end

            vim.notify(vim.inspect(handlers))

            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                handlers = handlers,
            })

            local diagnostic_opts = {
                float = { focusable = true, border = 'double' },
                -- Show gutter sings
                signs = {
                    severity = { min = 'HINT', max = 'ERROR' },
                },
                -- Show virtual text only for errors and warnings
                virtual_text = { severity = { min = 'WARN', max = 'ERROR' } },
                -- Don't update diagnostics when typing
                update_in_insert = false,
                severity_sort = true,

                source = true, -- always show diagnostics sources
            }

            vim.diagnostic.config(diagnostic_opts)

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP keymaps',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    -- these will be buffer-local keybindings
                    -- because they only work if you have an active language server

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set({ 'n', 'i' }, '<c-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end,
            })
        end,
    },
}
