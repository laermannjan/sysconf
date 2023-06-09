return {
  "LazyVim/LazyVim",
  opts = { colorscheme = "tokyonight" },
  dependencies = {
    { "folke/tokyonight.nvim", name = "tokyonight", opts = { style = "night" } },
    { "rose-pine/neovim", name = "rose-pine", opts = { variant = "auto" } }, -- moon
    { "ellisonleao/gruvbox.nvim", name = "gruvbox" },
    { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "moccha" } },
  },
}
