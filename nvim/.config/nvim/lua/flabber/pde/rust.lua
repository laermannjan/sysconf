if not vim.g.flabber.pde.rust then
    return {}
end

local M = {}

M.inlay_hints = true

return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust", "toml", "ron" })
        end,
    },
    {
        "mason-lspconfig.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust_analyzer", "taplo" })
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        dependencies = {
            "lsp-zero.nvim",
            opts = function(_, opts)
                -- rust tools sets up the lsp instead of lsp-zero
                vim.list_extend(opts.skip_server_setup, { "rust_analyzer" })
            end,
        },
        config = function(_, opts)
            local rust_tools = require("rust-tools")
            rust_tools.setup({
                server = {
                    on_attach = function(client, bufnr)
                        -- stylua: ignore
                        vim.keymap.set("n", "<leader>la", rust_tools.hover_actions.hover_actions,
                            { buffer = bufnr, desc = "Code action" })
                        -- stylua: ignore
                        vim.keymap.set("n", "<Leader>lA", rust_tools.code_action_group.code_action_group,
                            { buffer = bufnr, desc = "Code action group" }
                        )
                        vim.keymap.set("n", "<leader>lR", function()
                            require("rust-tools").runnables.runnables()
                        end, { buffer = bufnr, desc = "Runnables" })
                        vim.keymap.set("n", "<leader>lD", function()
                            require("rust-tools").debuggables()
                        end, { buffer = bufnr, desc = "Debuggables" })
                        vim.keymap.set("n", "<leader>lh", function()
                            local ih = require("rust-tools").inlay_hints
                            if M.inlay_hints == true then
                                ih.disable()
                                M.inlay_hints = false
                            else
                                ih.enable()
                                M.inlay_hints = true
                            end
                        end, { buffer = bufnr, desc = "Inlay hints" })
                    end,
                },
            })
        end,
    },
    {
        "neotest",
        dependencies = { "rouge8/neotest-rust" },
        opts = function(_, opts)
            vim.list_extend(opts.adapters, require("neotest-rust"))
        end,
    },
}
