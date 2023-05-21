return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust", "toml", "ron" })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = { "simrat39/rust-tools.nvim" },
        opts = function(_, opts)
            vim.list_extend(opts.lsp.ensure_installed, { "rust_analyzer", "taplo" })
            -- rust tools sets up the lsp instead of lsp-zero
            vim.list_extend(opts.lsp.skip_server_setup, { "rust_analyzer" })
            opts.lsp.post_lsp_setup_hooks.rust = function()
                local rust_tools = require("rust-tools")
                rust_tools.setup({
                    server = {
                        on_attach = function(client, bufnr)
                            vim.keymap.set(
                                "n",
                                "<leader>ca",
                                rust_tools.hover_actions.hover_actions,
                                { buffer = bufnr, desc = "Code action" }
                            )
                            vim.keymap.set(
                                "n",
                                "<Leader>cA",
                                rust_tools.code_action_group.code_action_group,
                                { buffer = bufnr, desc = "Code action group" }
                            )
                        end,
                    },
                })
            end
        end,
    },
}
