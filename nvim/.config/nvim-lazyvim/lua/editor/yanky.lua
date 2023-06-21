return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = {
      timer = 100,
    },
  },
  keys = {
    { "p", "<Plug>(YankyPutIndentAfterLinewise)" },
    { "P", "<Plug>(YankyPutIndentBeforeLinewise)" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
    { "<C-n>", "<Plug>(YankyCycleForward)" },
    { "<C-p>", "<Plug>(YankyCycleBackward)" },
  },
}
