vim.g.python3_host_prog = '~/.venv.nvim/bin/python3'
vim.g.colorscheme = 'tokyonight'
-- vim.g.colorscheme = 'randomhue'
-- vim.g.colorscheme = 'iceclimber'
-- vim.g.colorscheme = 'vague'

vim.g.enable_gitsigns = true

-- Bootstrap lazy.nvim
local lazypath = vim.env.LAZY or vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, 'lazy') then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '

require('options')
require('keymaps')

require('lazy').setup({
    spec = {
        { import = 'plugins' },
        { import = 'plugins/lang' },
        { import = 'plugins/themes' },
        { import = 'plugins/alts/blink' },
        { import = 'plugins/alts/heirline' },
    },
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = false,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { 'tokyonight', 'habamax' } },
    checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                'gzip',
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
})

vim.cmd.colorscheme(vim.g.colorscheme)
