local M = {
   "folke/todo-comments.nvim",
   lazy = false,
   cmd = { "TodoTrouble", "TodoTelescope" },
   keys = {
      {
         "]t",
         function()
            require("todo-comments").jump_next()
         end,
         desc = "next todo comment",
      },
      {
         "[t",
         function()
            require("todo-comments").jump_prev()
         end,
         desc = "previous todo comment",
      },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "find todo commends" },
   },
}

function M.config()
   local options = {
      signs = true, -- show icons in the signs column
      -- keywords recognized as todo comments
      keywords = {
         FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
         },
         TODO = { icon = " ", color = "info" },
         HACK = { icon = " ", color = "warning" },
         WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
         PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
         NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
         TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
   }

   require("todo-comments").setup(options)
end

return M
