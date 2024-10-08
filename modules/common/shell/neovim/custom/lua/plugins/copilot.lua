local C = {
   "zbirenbaum/copilot-cmp",
   enabled = true,
   dependencies = {
      {
         "zbirenbaum/copilot.lua",
         opts = { suggestion = { enabled = false }, panel = { enabled = false } },
         keys = function()
            return {}
         end,
      },
   },
   config = function()
      require("copilot_cmp").setup()
   end,
}
local M = {
   "zbirenbaum/copilot.lua",
   enabled = true,
   cmd = "Copilot",
   build = ":Copilot auth",
   event = "InsertEnter",
   opts = {
      -- panel = {
      --    keymap = {
      --       jump_next = "<c-j>",
      --       jump_prev = "<c-k>",
      --       accept = "<c-l>",
      --       refresh = "r",
      --       open = "<M-CR>",
      --    },
      -- },
      suggestion = {
         enabled = true,
         auto_trigger = true,
         keymap = {
            accept = false, -- INFO:  <S-CR> This is handled by cmp
            accept_word = false,
            accept_line = false, -- INFO: <Tab> This is handled by cmp
            next = false,
            prev = false,
            dismiss = false, -- INFO: <C-e> This is handled by cmp
         },
      },
      filetypes = {
         markdown = true,
         python = true,
         lua = true,
         vim = true,
         javascript = true,
         typescript = true,
         rust = true,
         go = true,
         terraform = true,
         html = true,
         css = true,
         ["*"] = false,
      },
      copilot_node_command = "node",
   },
   keys = {
      {
         "<leader>uC",
         ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>",
         { noremap = true, silent = true, desc = "toggle copilot auto suggestions" },
      },
   },
}

return { M, C }
