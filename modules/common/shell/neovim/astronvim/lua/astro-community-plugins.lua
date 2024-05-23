-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python-ruff" },

  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.fish" },

  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.full-dadbod" },

  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.pack.markdown" },

  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },

  { import = "astrocommunity.code-runner.overseer-nvim" },

  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.nightfox-nvim" },
  { import = "astrocommunity.colorscheme.rose-pine" },

  { import = "astrocommunity.programming-language-support.rest-nvim" },

  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.utility.noice-nvim" },

  { import = "astrocommunity.file-explorer.oil-nvim" },

  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" }, -- add treesitter highlight the DAP repl
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-chainsaw" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },

  { import = "astrocommunity.diagnostics.trouble-nvim" },

  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.wildfire-nvim" },

  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.lsp.delimited-nvim" },
  { import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.lsplinks-nvim" },
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },

  { import = "astrocommunity.motion.before-nvim" },
  { import = "astrocommunity.motion.grapple-nvim" },

  { import = "astrocommunity.recipes.disable-tabline" },

  { import = "astrocommunity.terminal-integration.flatten-nvim" },

  --
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "basedpyright" })
  --     opts.ensure_installed = vim.tbl_filter(
  --       function(v) return not vim.tbl_contains({ "pyright" }, v) end,
  --       opts.ensure_installed
  --     )
  --   end,
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "basedpyright" })
  --     opts.ensure_installed = vim.tbl_filter(
  --       function(v) return not vim.tbl_contains({ "pyright" }, v) end,
  --       opts.ensure_installed
  --     )
  --   end,
  -- },
}
