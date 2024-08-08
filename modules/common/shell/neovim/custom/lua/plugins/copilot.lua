local M = {
   "zbirenbaum/copilot.lua",
   enabled = true,
   cmd = "Copilot",
   event = "InsertEnter",
   -- dependencies = {
   -- 	"zbirenbaum/copilot-cmp",
   -- },
}

function M.config()
   require("copilot").setup {
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
         help = false,
         gitcommit = false,
         gitrebase = false,
         cvs = false,
         ["."] = false,
      },
      copilot_node_command = "node",
   }

   vim.keymap.set(
      "n",
      "<leader>uC",
      ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>",
      { noremap = true, silent = true, desc = "toggle copilot auto suggestions" }
   )

   -- require("copilot_cmp").setup()
end

return M
