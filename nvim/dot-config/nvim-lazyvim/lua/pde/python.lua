return {
  { import = "lazyvim.plugins.extras.lang.python" },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        -- Order of formatters matters. They are used in order of appearance.
        nls.builtins.diagnostics.mypy.with({ prefer_local = ".venv" }),
        nls.builtins.formatting.ruff.with({ prefer_local = ".venv" }),
        nls.builtins.formatting.black.with({ prefer_local = ".venv" }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
        },
      },
    },
  },
}
