vim.g.colorscheme = "tokyonight"
-- vim.g.colorscheme = "base16-classic-dark"
-- vim.g.colorscheme = "tokyodark"
-- vim.g.colorscheme = "astrodark"
-- vim.g.colorscheme = "nightfox"
-- vim.g.colorscheme = "duskfox"
-- vim.g.colorscheme = "terafox"
-- vim.g.colorscheme = "nordic"

vim.g.plugin_specs = {
   { import = "plugins.notify" },
   { import = "plugins.colorschemes" },
   { import = "plugins.devicons" },
   { import = "plugins.treesitter" },
   -- {import = "plugins.lsp"},
   -- {import = "plugins.cmp"},
   { import = "plugins.lsp-zero" },
   { import = "plugins.none-ls" },
   { import = "plugins.which-key" },
   { import = "plugins.telescope" },
   { import = "plugins.trouble" },
   { import = "plugins.neotree" },
   { import = "plugins.comment" },
   { import = "plugins.fidget" },
   { import = "plugins.neotab" },
   { import = "plugins.todo-comments" },
   { import = "plugins.hmts" },
   { import = "plugins.heirline" },
   { import = "plugins.grapple" },
   -- {import = "plugins.ufo"}, -- TODO: see launch.nvim config
   { import = "plugins.copilot" },
   -- {import = "plugins.gitlinker"},
   { import = "plugins.gitsigns" },
   -- {import = "plugins.diffview"},
   { import = "plugins.autopairs" },
   { import = "plugins.toggleterm" },
   { import = "plugins.neotest" },
   -- { import = "plugins.various-textobjects" },

   { import = "plugins.mini-ai" },
   { import = "plugins.mini-operators" },
   { import = "plugins.mini-surround" },

   { import = "plugins.smart-splits" },
   { import = "plugins.kulala" },
   { import = "plugins.oil" },
}

require "config.options"
require "config.keymaps"
require "config.autocmds"
require "config.lazy"
