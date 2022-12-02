local M = {}

local function get_venv_path()
   local path = require("config.lsp.utils").get_pipenv_path()
   vim.notify("my path: " .. path)
   -- vim.notify("cwd: " .. vim.fn.getcwd())
   -- local path = vim.fn.system("pipenv --venv")
   -- if path then
   --    vim.notify("path: " .. path)
   -- else
   --    vim.notify("other path")
   -- end
end

M.setup = function()
   local present, lsp = pcall(require, "lsp-zero")
   if not present then
      utils.warn("lsp-zero could not be required.", "lsp-config")
      return
   end

   local present, null_ls = pcall(require, "null-ls")
   if not present then
      utils.warn("null-ls could not be required", "lsp-config")
      return
   end

   local null_opts = lsp.build_options('null-ls', {
      on_attach = function(client)
         -- if client.resolved_capabilities.document_formatting then
         --    vim.api.nvim_create_autocmd("BufWritePre", {
         --       desc = "Auto format before save",
         --       pattern = "<buffer>",
         --       callback = vim.lsp.buf.formatting_sync,
         --    })
         -- end
      end,

      sources = {
         -- english
         null_ls.builtins.diagnostics.write_good,

         -- python
         null_ls.builtins.formatting.black.with {
            command = require("config.lsp.utils").get_python_bin_path { bin = "black" },
            extra_args = { "--fast" }
         },
         null_ls.builtins.formatting.isort.with {
            command = require("config.lsp.utils").get_python_bin_path { bin = "isort" }
         },
         null_ls.builtins.diagnostics.flake8.with {
            command = require("config.lsp.utils").get_python_bin_path { bin = "flake8" },
            extra_args = { "--max-line-length=180" }
         },
         null_ls.builtins.diagnostics.mypy.with {
            command = require("config.lsp.utils").get_python_bin_path { bin = "mypy" }
         },
         -- -- The Refactoring library based off the Refactoring book by Martin Fowler
         -- null_ls.builtins.code_actions.refactoring,
         -- -- Semgrep is a fast, open-source, static analysis tool for finding bugs and enforcing code standards at editor, commit, and CI time
         -- null_ls.builtins.diagnostics.semgrep,
         -- -- Vulture finds unused code in Python programs.
         -- null_ls.builtins.diagnostics.vulture,

         -- beancount
         null_ls.builtins.formatting.bean_format,

         -- -- git
         -- null_ls.builtins.code_actions.gitrebase,
         -- null_ls.builtins.code_actions.gitsigns.with {
         --    disabled_filetypes = { "NeogitCommitMessage" },
         -- },
      }
   })

   null_ls.setup(null_opts)
end

return M
