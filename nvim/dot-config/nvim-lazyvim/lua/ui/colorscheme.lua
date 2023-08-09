return {
  "LazyVim/LazyVim",
  opts = { colorscheme = "tokyonight" },
  dependencies = {
    { "folke/tokyonight.nvim", opts = { style = "night" }, lazy = true },
    { "rose-pine/neovim", name = "rose-pine", opts = { variant = "auto" }, lazy = true, enabled = false }, -- moon
    { "ellisonleao/gruvbox.nvim", lazy = true, enabled = false },
    {
      "catppuccin/nvim",
      lazy = true,
      enabled = false,
      name = "catppuccin",
      opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
      },
    },
  },
}
