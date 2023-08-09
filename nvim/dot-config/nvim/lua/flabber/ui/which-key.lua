return {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    opts = {
        icons = {
            group = "", -- groups already have their own icons
            separator = "",
        },
        disable = { filetypes = { "TelescopePrompt" } },
    },
    config = function(_, opts)
        -- vim.o.timeout = true
        -- vim.o.timeoutlen = 300
        local wk = require("which-key")
        wk.setup(opts)

        wk.register({
            ["<leader>"] = {
                f = { name = "󰍉 Find" },
                p = { name = "󰏖 Packages" },
                l = { name = " LSP" },
                u = { name = " UI" },
                b = { name = "󰓩 Buffers" },
                -- bs = { name = "󰒺 Sort Buffers" },
                d = { name = " Debugger" },
                g = { name = "󰊢 Git" },
                -- S = { name = "󱂬 Session" },
                t = { name = " Tests" },
                T = { name = " Terminal" },
                x = { name = " Trouble" },
            },
        })
    end,
}
