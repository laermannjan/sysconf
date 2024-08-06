vim.g.colorscheme = "tokyonight"
-- vim.g.colorscheme = "tokyodark"
-- vim.g.colorscheme = "astrodark"
-- vim.g.colorscheme = "nightfox"
-- vim.g.colorscheme = "duskfox"
-- vim.g.colorscheme = "terafox"
-- vim.g.colorscheme = "nordic"

vim.g.plugin_specs = {
    {import = "user.colorschemes"},
    {import = "user.devicons"},
    {import = "user.treesitter"},
    -- {import = "user.lsp"},
    -- {import = "user.none-ls"},
    -- {import = "user.cmp"},
    {import = "user.lsp-zeroo"},
    {import = "user.which-key"},
    {import = "user.telescope"},
    {import = "user.trouble"},
    {import = "user.neotree"},
    {import = "user.comment"},
    {import = "user.fidget"},
    {import = "user.neotab"},
    {import = "user.todo-comments"},
    {import = "user.hmts"},
    -- {import = "user.astroline"},
    {import = "user.heirline"},
    {import = "user.grapple"},
    -- {import = "user.staline"},
    -- {import = "user.ufo"}, -- TODO: see launch.nvim config
    {import = "user.copilot"},
    -- {import = "user.gitlinker"},
    {import = "user.gitsigns"},
    -- {import = "user.diffview"},
    {import = "user.autopairs"},
    -- {import = "user.lualine"},
    {import = "user.toggleterm"},
    {import = "user.neotest"},
    {import = "user.various-textobjects"},
    {import = "user.smart-splits"},
    -- {import = "user.rest"},
    {import = "user.kulala"},
}

require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.lazy"
