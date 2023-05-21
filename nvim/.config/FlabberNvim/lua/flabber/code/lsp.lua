local lsp_diagnostic_signs = {
    error = "✘",
    warn = "▲",
    hint = "⚑",
    info = "»",
}

local cmp_kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
    Copilot = "",
}

local cmp_menu_names = {
    nvim_lua = "Nvim",
    nvim_lsp = "LSP",
    luasnip = "Snippet",
    buffer = "Buffer",
    path = "Path",
    copilot = "AI",
}

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- Tool installer
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
                opts = { ensure_installed = {} },
            },

            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason-lspconfig.nvim" },

            {
                "jay-babu/mason-null-ls.nvim",
                dependencies = {
                    "williamboman/mason.nvim",
                    "jose-elias-alvarez/null-ls.nvim",
                },
            },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" }, -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            {
                "L3MON4D3/LuaSnip", -- Required
                dependencies = {
                    "rafamadriz/friendly-snippets", -- Optional
                },
            },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },

            -- AI assistant completion
            {
                "zbirenbaum/copilot-cmp",
                dependencies = {
                    "zbirenbaum/copilot.lua",
                    opts = {
                        suggestions = { enabled = false },
                        panel = { enabled = false },
                    },
                },
            },
        },
        opts = {
            lsp = {
                diagnostic_signs = lsp_diagnostic_signs,
                ensure_installed = {},
                skip_server_setup = {},
                pre_lsp_setup_hooks = {},
                post_lsp_setup_hooks = {},
            },
            cmp = {
                menu_names = cmp_menu_names,
                sources = {

                    { name = "copilot", group_index = 2 },
                    { name = "path", group_index = 2 },
                    { name = "nvim_lua", group_index = 2 },
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "buffer", group_index = 2, keyword_length = 3 },
                    { name = "luasnip", group_index = 2, keyword_length = 3 },
                },
            },
            null_ls = {
                sources = {},
            },
        },
        config = function(_, opts)
            -- LSP setup
            local lsp = require("lsp-zero").preset({
                float_border = "rounded",
                configure_diagnostics = true,
                setup_servers_on_start = true,

                manage_nvim_cmp = {
                    set_sources = false,
                    set_basic_mappings = true,
                    set_extra_mappings = false,
                    use_luasnip = true,
                    set_format = true,
                    documentation_window = true,
                },
            })

            lsp.ensure_installed(opts.lsp.ensure_installed)
            lsp.set_sign_icons(opts.lsp.diagnostic_signs)

            lsp.on_attach(function(client, bufnr)
                -- lsp.default_keymaps({ bufnr = bufnr })
                --
                function opts(desc)
                    return { buffer = bufnr, remap = false, desc = desc }
                end

                -- stylua: ignore start
                vim.keymap.set({ "n", "x" }, "=", function() vim.lsp.buf.format() end, opts("Format"))
                vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts("Rename current symbol"))
                vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts("Code Action"))

                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts("Hover docs"))
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts("Go to Definition"))
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts("Go to Declaration"))
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts("Go to Implementation"))
                vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts("Go to Implementation"))
                vim.keymap.set("n", "gl", function() vim.lsp.buf.signature_help() end, opts("Get Signature Help"))
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts("Go to references"))

                vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts("Show diagnostic"))
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts("Previous diagnostic"))
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts("Next diagnostic"))
                -- stylua: ignore end

                lsp.buffer_autoformat({ async = false }) -- runs all attached LSPs with formatting capabilities (in no guaranteed order)
            end)

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls()) -- sets up the `lua_ls` lsp for the neovim api

            lsp.skip_server_setup(opts.lsp.skip_server_setup)

            for lang, fn in pairs(opts.lsp.pre_lsp_setup_hooks) do
                fn()
            end

            lsp.setup()

            for lang, fn in pairs(opts.lsp.post_lsp_setup_hooks) do
                fn(lsp)
            end
            -- Autocompletion setup
            require("luasnip.loaders.from_vscode").lazy_load() -- required by friendly-snippets

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()
            cmp.setup({
                sources = opts.cmp.sources,
                mapping = {
                    -- `Enter` key to confirm completion and insert at cursor
                    ["<CR>"] = cmp.mapping.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Insert,
                    }),
                    -- `Tab` key to confirm (or autoselect first entry) and replace from cursor until end of word
                    ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),

                    -- Ctrl+Space to trigger completion menu
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                },
                -- styling
                window = {
                    -- look here for customizations https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local kind_symbol = cmp_kind_icons[item.kind]
                        local menu_name = cmp_menu_names[entry.source.name] or entry.source.name

                        item.kind = string.format("%s ", kind_symbol)
                        item.menu = string.format("[%s]", menu_name)

                        return item
                    end,
                },
            })

            require("null-ls").setup({ sources = opts.null_ls.sources })
            require("mason-null-ls").setup({
                ensure_installed = nil,
                automatic_installation = true,
            })
        end,
    },

    -- load extra language configs
    { import = "flabber.code.langs.lua" },
    { import = "flabber.code.langs.python" },
    { import = "flabber.code.langs.rust" },
    { import = "flabber.code.langs.beancount" },
}
