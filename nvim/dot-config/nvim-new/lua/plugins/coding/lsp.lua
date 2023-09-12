return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
        opts = {
            ui = {
                border = "rounded"
            }
        }
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'crispgm/cmp-beancount' },
            { 'andersevenrud/cmp-tmux' },
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = {
                    -- TODO: maybe use cmp.mapping.preset.insert({...}) instead, check in lsp-zero what it does
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<S-CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                },
                sources = {
                    {
                        name = 'beancount',
                        option = {
                            account = '~/Documents/Finanzen/Haushaltsbuch/new_beans/ledger/main.beancount'
                        }
                    },
                    { name = "tmux",                  label = '[tmux]', group_index = 2 },
                    { name = "orgmode",               label = '[Org]',  group_index = 2 },
                    -- { name = "neorg",                 label = '[Neorg]', group_index = 2 },
                    { name = "vim-dadbod-completion", label = '[SQL]',  group_index = 2 },
                    { name = "path",                  group_index = 2 },
                    { name = "nvim_lua",              group_index = 2 },
                    { name = "nvim_lsp",              group_index = 2 },
                    { name = "luasnip",               group_index = 2,  keyword_length = 3 },
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live

            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                    preserve_mappings = false
                })
                lsp_zero.buffer_autoformat()
            end)

            lsp_zero.set_sign_icons(vim.g.flabber__diagnostics_signs)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    -- lua
                    'lua_ls',

                    -- python
                    'pyright',
                    'ruff_lsp',

                    -- rust
                    'rust_analyzer'
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
                    end,
                }
            })
        end
    },

    -- Null-ls
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function(_, opts)
            local null_ls = require("null-ls")
            opts.sources = opts.sources or {}
            vim.tbl_extend("force", opts.sources, {
                -- python
                null_ls.builtins.formatting.black.with({ filetypes = { "python" }, prefer_local = ".venv/bin" }),
                null_ls.builtins.diagnostics.mypy.with({ filetypes = { "python" }, prefer_local = ".venv/bin" }),
                -- lua
                null_ls.builtins.formatting.stylua,
            })
            null_ls.setup(opts)
        end
    },

    {
        "jay-babu/mason-null-ls.nvim",
        opts = {
            ensure_installed = nil,
            automatic_installation = true,
        }
    },
}
