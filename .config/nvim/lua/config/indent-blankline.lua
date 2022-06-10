require("indent_blankline").setup({
  char = "┊",
  buftype_exclude = { "terminal" },
  filetype_exclude = { "startify", "help", "dashboard", "Outline" },
  indent_blankline_use_treesitter = true,
  indent_blankline_show_current_context = true,
  show_trailing_blankline_indent = false,
})
