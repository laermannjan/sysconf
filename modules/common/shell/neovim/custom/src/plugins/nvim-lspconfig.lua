-- All language servers are expected to be installed with 'mason.vnim'.

local add = MiniDeps.add

add({
    source = 'saghen/blink.cmp',
    depends = {
        'saghen/blink.compat',
        'rafamadriz/friendly-snippets',
        'crispgm/cmp-beancount',
        'giuxtaposition/blink-cmp-copilot',
        'zbirenbaum/copilot.lua',
        'kawre/neotab.nvim',
    },
    checkout = 'v0.5.1',
    monitor = 'main',
})

add({ source = 'folke/lazydev.nvim', depends = { 'Bilal2453/luvit-meta', 'justinsgithub/wezterm-types' } })

add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
    },
})

-- LazyDev config ===========================================================

require('lazydev').setup({
    library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
    },
})

-- CMP config ===============================================================

require('neotab').setup({})
require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', function(cmp) require('neotab').tabout() end, 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    accept = { auto_brackets = { enabled = true } },
    trigger = { completion = { keyword_range = 'prefix' }, signature_help = { enabled = true } },
    windows = { autocomplete = { selection = 'manual' }, documentation = { auto_show = true, auto_show_delay_ms = 500 }, ghost_text = { enabled = true } },
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
})

-- LSP config ==============================================================

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

local setup_server = function(server, opts)
    opts = opts or {}
    local common_opts = {
        -- cmp can handle more types of completion candidates than neovim's omnifunc
        -- these 'capabilities' must be advertised to the LSP
        -- capabilities = require('cmp_nvim_lsp').default_capabilities(),

        capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('blink.cmp').get_lsp_capabilities()),
    }
    opts = vim.tbl_deep_extend('error', common_opts, opts)
    require('lspconfig')[server].setup(opts)
end

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright',
        -- 'ruff',
        'gopls',
    },
    handlers = {
        function(server) setup_server(server) end,
        lua_ls = function()
            local opts = {
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
            }
            setup_server('lua_ls', opts)
        end,
        pyright = function()
            local opts = {
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
            }
            -- setup_server('pyright', opts)
        end,
        basedpyright = function()
            local opts = {
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
                            stubPath = vim.env.HOME .. '/typings',
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
            }
            setup_server('basedpyright', opts)
        end,
        gopls = function()
            local opts = {
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
            }
            setup_server('gopls', opts)
        end,
        ruff = function()
            local opts = {
                on_attach = function(client, bufnr)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                end,
            }
            setup_server('ruff', opts)
        end,
    },
})

setup_server('kulala_ls') -- NOTE: remove once it's in mason

-- add({
--     source = 'hrsh7th/nvim-cmp',
--     depends = {
--         'hrsh7th/cmp-nvim-lsp',
--         'hrsh7th/cmp-buffer',
--         'hrsh7th/cmp-path',
--         'hrsh7th/cmp-nvim-lsp-signature-help',
--         'aznhe21/actions-preview.nvim',
--         { source = 'L3MON4D3/LuaSnip', depends = { 'saadparwaiz1/cmp_luasnip' } },
--         { source = 'folke/lazydev.nvim', depends = { 'Bilal2453/luvit-meta' } },
--     },
-- })
--
-- local cmp = require('cmp')
-- local luasnip = require('luasnip')
--
-- -- this is the function that loads the extra snippets
-- -- from rafamadriz/friendly-snippets
-- require('luasnip.loaders.from_vscode').lazy_load()
--
-- cmp.setup({
--     sources = {
--         -- { name = "copilot", priority = 10000 },
--         { name = 'path' },
--         { name = 'nvim_lsp' },
--         { name = 'lazydev', group_index = 0 },
--         { name = 'nvim_lsp_signature_help' },
--         { name = 'luasnip', keyword_length = 2 },
--         { name = 'buffer', keyword_length = 3 },
--     },
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
--     snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
--     mapping = cmp.mapping.preset.insert({
--
--         ['<C-p>'] = cmp.mapping(function(fallback)
--             local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
--             if cmp.visible() then
--                 cmp.select_prev_item()
--             elseif ok_copilot and copilot.is_visible() then
--                 copilot.prev()
--             else
--                 fallback()
--             end
--         end, { 'i', 'c' }),
--         ['<C-n>'] = cmp.mapping(function(fallback)
--             local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
--             if cmp.visible() then
--                 cmp.select_next_item()
--             elseif ok_copilot and copilot.is_visible() then
--                 copilot.next()
--             else
--                 fallback()
--             end
--         end, { 'i', 'c' }),
--         ['<C-u>'] = cmp.mapping.scroll_docs(-2),
--         ['<C-d>'] = cmp.mapping.scroll_docs(2),
--         ['<C-e>'] = cmp.mapping(function(fallback)
--             local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
--             if cmp.visible() then
--                 cmp.abort()
--                 cmp.close()
--             elseif ok_copilot and copilot.is_visible() then
--                 copilot.dismiss()
--             else
--                 fallback()
--             end
--         end, { 'i', 'c' }),
--         ['<S-CR>'] = cmp.mapping(function(fallback)
--             local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
--             if ok_copilot and copilot.is_visible() then
--                 copilot.accept()
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--         ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
--         ['<Tab>'] = cmp.mapping(function(fallback)
--             local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
--             local ok_neotab, neotab = pcall(require, 'neotab')
--
--             if ok_copilot and copilot.is_visible() then
--                 copilot.accept_line()
--             elseif cmp.visible() then
--                 cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
--             elseif luasnip.expandable() then
--                 luasnip.expand()
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             elseif ok_neotab then
--                 neotab.tabout()
--             else
--                 fallback()
--             end
--         end, {
--             'i',
--             's',
--         }),
--         ['<S-Tab>'] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(-1) then
--                 luasnip.jump(-1)
--             else
--                 fallback()
--             end
--         end, {
--             'i',
--             's',
--         }),
--     }),
--     -- note: if you are going to use lsp-kind (another plugin)
--     -- replace the line below with the function from lsp-kind
--     -- formatting = lsp_zero.cmp_format({ details = true }),
-- })
