return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "beancount" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "beancount-language-server" })
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.bean_format.with({ prefer_local = ".venv" }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      format_notify = true,
      servers = {
        beancount = {
          init_options = {
            -- journal_file = "/Users/jan/Documents/Finanzen/Haushaltsbuch/new_beans/test.beancount",
            journal_file = "/Users/jan/Documents/Finanzen/Haushaltsbuch/new_beans/ledger/main.beancount",
          },
        },
      },
    },
  },
}
