return {
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = { "stevearc/overseer.nvim" },
  --   opts = function(_, opts)
  --     opts = vim.tbl_deep_extend("force", opts, {
  --       consumers = {
  --         overseer = require("neotest.consumers.overseer"),
  --       },
  --       overseer = {
  --         enabled = true,
  --         force_default = true,
  --       },
  --     })
  --     return opts
  --   end,
  -- },
  -- {
  --   "stevearc/overseer.nvim",
  --   config = true,
  -- },
}