return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/neotest-python",
        "antoinemadec/FixCursorHold.nvim",
    },
    opts = function(_, opts)
        return { adapters = require("neotest-python") }
    end, -- stylua: ignore
    keys = {
        {
            "<leader>T",
            function()
                require("neotest").run.run()
            end,
            desc = "Run nearest",
        },
    },
}
