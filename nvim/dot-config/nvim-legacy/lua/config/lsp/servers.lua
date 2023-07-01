local M = {}
M.setup = function()
   local present, lsp = pcall(require, "lsp-zero")
   if not present then
      require("utils").warn("could not require lsp-zero for LSP server setup")
      return
   end

   -- lua
   lsp.configure("sumneko_lua", {
      settings = {
         Lua = {
            diagnostics = {
               globals = { "vim" }
            }
         }
      }
   })

   -- rust
   local rust_lsp = lsp.build_options('rust_analyzer', {
      cargo = { allFeatures = true },
      checkOnSave = {
         command = "cargo clippy",
         extraArgs = { "--no-deps" },
      }
   })
   require('rust-tools').setup({ server = rust_lsp })

   -- python
   lsp.configure("pyright", {
      before_init = function(_, config)
         local python_path = require("config.lsp.utils").get_python_bin_path { bin = "python" }
         require("utils").debug("setting python_path: " .. python_path, "pyright setup")
         config.settings.python.pythonPath = python_path
      end,
      settings = {
         pyright = {
            disableOrganizeImports = true
         },
         python = {
            analysis = {
               typeCheckingMode = "off",
               autoSearchPaths = true,
               useLibraryCodeForTypes = true,
               diagnosticMode = "workspace",
            },
         },
      },
   })
end

return M
