return {
  -- external tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "stylua",
        "luacheck",
        "eslint_d",
        "shellcheck",
        "shfmt",
        "black",
        "isort",
        "flake8",
      },
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        clangd = {},
        cssls = {},
        dockerls = {},
        tsserver = {},
        svelte = {},
        eslint = {},
        html = {},
        gopls = {},
        marksman = {},
        pyright = {
          settings = {
            Python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
        yamlls = {},
        vimls = {},
      },
    },
    setup = {
      pyright = function(_, opts)
        local lsp_utils = require("plugins.lsp.utils")
        lsp_utils.on_attach(function(client, buffer)
          -- stylua: ignore
          if client.name == "pyright" then
            vim.keymap.set("n", "<leader>tC", function() require("dap-python").test_class() end,
              { buffer = buffer, desc = "Debug Class" })
            vim.keymap.set("n", "<leader>tM", function() require("dap-python").test_method() end,
              { buffer = buffer, desc = "Debug Method" })
            vim.keymap.set("v", "<leader>tS", function() require("dap-python").debug_selection() end,
              { buffer = buffer, desc = "Debug Selection" })
          end
        end)
      end,
    },
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.fish_indent,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.luacheck,
          nls.builtins.code_actions.gitsigns,
          --
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,
          nls.builtins.diagnostics.flake8,
          -- nls.builtins.diagnostics.ruff,
          nls.builtins.diagnostics.mypy,

          nls.builtins.formatting.bean_format,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
      })
    end,
  },
}
