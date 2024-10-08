return {
   "nvimtools/none-ls.nvim",
   dependencies = { "jay-babu/mason-null-ls.nvim", "williamboman/mason.nvim" },
   config = function()
      local null_ls = require "null-ls"

      null_ls.setup {
         debug = false,
         -- on_attach = function(client, bufnr)
         --    require("config.utils").create_autoformat_autocmd(client, bufnr)
         -- end,

         sources = {
            null_ls.builtins.formatting.stylua,
            -- null_ls.builtins.diagnostics.selene, -- NOTE: disabled; interferes with stylua

            null_ls.builtins.formatting.prettier,

            null_ls.builtins.code_actions.gomodifytags,
            null_ls.builtins.code_actions.impl,
            null_ls.builtins.formatting.goimports,
            null_ls.builtins.formatting.gofumpt,
            null_ls.builtins.diagnostics.mypy.with { prefer_local = ".venv/bin" },

            -- formatting.prettier.with {
            --   extra_filetypes = { "toml" },
            --   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            -- },
            -- formatting.eslint,
            -- null_ls.builtins.diagnostics.eslint,

            null_ls.builtins.code_actions.statix,
            null_ls.builtins.formatting.nixfmt,
            null_ls.builtins.diagnostics.deadnix,
         },
      }

      require("mason-null-ls").setup {
         ---@diagnostic disable: assign-type-mismatch
         ensure_installed = nil,
         automatic_installation = true,
      }
   end,
}
