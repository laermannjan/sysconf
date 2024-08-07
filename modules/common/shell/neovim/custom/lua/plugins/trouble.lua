local M = {
   "folke/trouble.nvim",
   opts = {},
   cmd = "Trouble",
   keys = {
      {
         "<leader>cd",
         "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
         desc = "Diagnostics (Trouble)",
      },
      {
         "<leader>cs",
         "<cmd>Trouble symbols toggle focus=false<cr>",
         desc = "Symbols (Trouble)",
      },
      {
         "<leader>cL",
         "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
         desc = "LSP Definitions / references / ... (Trouble)",
      },
   },
}

return M
