-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.filetype.add({
  pattern = {
    [".*git/config"] = "gitconfig",
    [".*git/ignore"] = "gitignore",
  },
})
