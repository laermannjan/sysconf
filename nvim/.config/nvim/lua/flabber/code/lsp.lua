-- local lsp_diagnostic_signs = {
--     error = "✘",
--     warn = "▲",
--     hint = "⚑",
--     info = "»",
-- }
-- local cmp_kind_icons = {
--     Text = "",
--     Method = "󰆧",
--     Function = "󰊕",
--     Constructor = "",
--     Field = "󰇽",
--     Variable = "󰂡",
--     Class = "󰠱",
--     Interface = "",
--     Module = "",
--     Property = "󰜢",
--     Unit = "",
--     Value = "󰎠",
--     Enum = "",
--     Keyword = "󰌋",
--     Snippet = "",
--     Color = "󰏘",
--     File = "󰈙",
--     Reference = "",
--     Folder = "󰉋",
--     EnumMember = "",
--     Constant = "󰏿",
--     Struct = "",
--     Event = "",
--     Operator = "󰆕",
--     TypeParameter = "󰅲",
--     Copilot = "",
-- }
--
-- local cmp_menu_names = {
--     nvim_lua = "Nvim",
--     nvim_lsp = "LSP",
--     luasnip = "Snippet",
--     buffer = "Buffer",
--     path = "Path",
--     copilot = "AI",
-- }

local M = {}
M.autoformat = nil

local function toggle_autoformat()
    if M.autoformat == nil then
        M.autoformat = vim.g.flabber.editor.autoformat
    end
    M.autoformat = not M.autoformat
    vim.b.lsp_zero_enable_autoformat = M.autoformat
    vim.notify("Autoformat is now " .. (M.autoformat and "enabled" or "disabled"))
end

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
            "williamboman/mason.nvim",

            "hrsh7th/nvim-cmp", -- Required
            "hrsh7th/cmp-nvim-lsp", -- Required
            "L3MON4D3/LuaSnip", -- Required
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
            },
            -- AI assistant completion
            {
                "zbirenbaum/copilot-cmp",
                opts = true,
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
            skip_server_setup = {},
        },
        config = function(_, opts)
            -- LSP setup
            local lsp = require("lsp-zero").preset({
                float_border = "solid",
                call_servers = "local",
                configure_diagnostics = true,
                setup_servers_on_start = true,
                set_lsp_keymaps = {
                    preserve_mappings = false,
                    omit = {},
                },
                manage_nvim_cmp = {
                    set_sources = "recommended",
                    set_basic_mappings = true,
                    set_extra_mappings = false,
                    use_luasnip = true,
                    -- set_format = true,
                    documentation_window = true,
                },
            })

            lsp.set_sign_icons(require("flabber.config.icons").diagnostics)

            lsp.on_attach(function(client, bufnr)
                function wrap(desc)
                    return { buffer = bufnr, remap = false, desc = desc }
                end

                -- stylua: ignore start
                vim.keymap.set({ "n", "x" }, "=", function() vim.lsp.buf.format() end, wrap("Format"))
                vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, wrap("Rename current symbol"))
                vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, wrap("Code Action"))

                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, wrap("Hover docs"))
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, wrap("Go to Definition"))
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, wrap("Go to Declaration"))
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, wrap("Go to Implementation"))
                vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, wrap("Go to Implementation"))
                vim.keymap.set("n", "gl", function() vim.lsp.buf.signature_help() end, wrap("Get Signature Help"))
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, wrap("Go to references"))

                vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, wrap("Show diagnostic"))
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, wrap("Previous diagnostic"))
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, wrap("Next diagnostic"))


                vim.keymap.set("n", "<leader>af", toggle_autoformat,
                    { buffer = 0, remap = true, desc = "Toggle autoformat" })
                -- stylua: ignore end
                lsp.buffer_autoformat({ async = false }) -- runs all attached LSPs with formatting capabilities (in no guaranteed order)
            end)

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls()) -- sets up the `lua_ls` lsp for the neovim api

            lsp.skip_server_setup(opts.skip_server_setup)
            lsp.setup()

            -- CMP setup

            require("luasnip.loaders.from_vscode").lazy_load() -- required by friendly-snippets

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()
            cmp.setup({
                sources = {
                    { name = "copilot", group_index = 2 },
                    { name = "path", group_index = 2 },
                    { name = "nvim_lua", group_index = 2 },
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "buffer", group_index = 2, keyword_length = 3 },
                    { name = "luasnip", group_index = 2, keyword_length = 3 },
                },
                mapping = {
                    -- `Enter` key to confirm completion and insert at cursor
                    ["<S-CR>"] = cmp.mapping.confirm({
                        select = true,
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
                -- window = {
                --     -- look here for customizations https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
                --     completion = cmp.config.window.bordered(),
                --     documentation = cmp.config.window.bordered(),
                -- },
                -- formatting = {
                --     fields = { "kind", "abbr", "menu" },
                --     format = function(entry, item)
                --         local kind_symbol = cmp_kind_icons[item.kind]
                --         local menu_name = cmp_menu_names[entry.source.name] or entry.source.name
                --
                --         item.kind = string.format("%s ", kind_symbol)
                --         item.menu = string.format("[%s]", menu_name)
                --
                --         return item
                --     end,
                -- },
            })
        end,
    },
}
