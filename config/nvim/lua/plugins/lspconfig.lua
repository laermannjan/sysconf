return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = '${3rd}/love2d/library', words = { 'love' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
            },
        },
    },
    {
        'williamboman/mason.nvim',
        -- cmd = 'Mason',
        build = ':MasonUpdate',
        opts = {
            ensure_installed = {
                'stylua',
                'shfmt',
            },
        },
        opts_extend = { 'ensure_installed' },
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end)
        end,
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
                    local opts = function(local_opts)
                        local default = { buffer = event.buf }
                        local_opts = vim.tbl_extend('force', default, local_opts or {})
                        return local_opts
                    end

                    -- these will be buffer-local keybindings
                    -- because they only work if you have an active language server

                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts({ desc = 'References' }))
                    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts({ desc = 'Rename symbol' }))
                    vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts({ desc = 'Code action' }))
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts({ desc = 'Definition' }))
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts({ desc = 'Declaration' }))
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts({ desc = 'Implementation' }))
                    vim.keymap.set('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts({ desc = 'Type definition' }))
                    vim.keymap.set({ 'n', 'x' }, '=', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts({ desc = 'Format' })) -- NOTE: use gq to sync format
                end,
            })
        end,
    },
}
