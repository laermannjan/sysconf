local M = {}

function M.setup()
   require("project_nvim").setup {
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "Makefile", "cargo.toml", "setup.py" },
      ignore_lsp = { "null-ls" },
      silent_chdir = false,
   }
end

return M
