if not vim.g.flabber.pde.rust then
    return {}
end

return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust", "toml", "ron" })
        end,
    },
    {
        "mason.nvim",
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
                        vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions,
                            { buffer = bufnr, desc = "Code action" })
                        -- stylua: ignore
                        vim.keymap.set("n", "<Leader>cA", rust_tools.code_action_group.code_action_group,
                            { buffer = bufnr, desc = "Code action group" }
                        )
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
