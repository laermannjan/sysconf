return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'dev-v3', -- TODO: update this to v3 stable after 20.09.2023 (proposed release date)
        lazy = true,
        config = false,
    },
    {
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
        lazy = true,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            require('lsp-zero').extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                mapping = {
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }
            })
        end
    },

    -- LSP
    {
        'williamboman/mason-lspconfig.nvim',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live

            local lsp = require('lsp-zero').preset({})

            lsp.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })
                lsp.buffer_autoformat()
            end)

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
                    lsp.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
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
