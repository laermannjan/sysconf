vim.g.colorscheme = 'tokyonight'
-- vim.g.colorscheme = 'randomhue'

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

require('lazy').setup({
    spec = {
        { import = 'plugins' },
        { import = 'plugins/lang' },
        { import = 'plugins/themes' },
        { import = 'plugins/tryout/blink' },
        { import = 'plugins/tryout/copilot' },
        { import = 'plugins/tryout/copilot-chat' },
        { import = 'plugins/tryout/heirline' },
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

-- -- Initialization =============================================================
-- pcall(function() vim.loader.enable() end)
--
-- -- Define main config table
-- _G.Config = {
--     install_path = vim.fn.stdpath('data') .. '/site/',
--     source_path = vim.fn.stdpath('config') .. '/src/',
--     -- source_path = vim.fn.expand('%:h') .. '/src/',
-- }
-- --------------------
-- -- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
-- local mini_path = Config.install_path .. 'pack/deps/start/mini.nvim'
-- if not vim.loop.fs_stat(mini_path) then
--     vim.cmd('echo "Installing `mini.nvim`" | redraw')
--     local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
--     vim.fn.system(clone_cmd)
--     vim.cmd('packadd mini.nvim | helptags ALL')
--     vim.cmd('echo "Installed `mini.nvim`" | redraw')
-- end
--
-- -- Set up 'mini.deps' (customize to your liking)
-- require('mini.deps').setup({ path = { package = Config.install_path } })
--
-- -- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- -- startup and are optional.
-- local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
-- local source = function(path) dofile(Config.source_path .. path) end
--
-- -- Options and mappings =====================================================
-- now(function() source('options.lua') end)
-- now(function() source('functions.lua') end)
-- now(function() source('keymaps.lua') end)
-- -- if vim.g.vscode ~= nil then now(function() source('vscode.lua') end) end
--
-- -- Plugins ==================================================================
-- add({ name = 'mini.nvim' })
--
-- -- now(function()  end)
-- vim.filetype.add({
--     extension = {
--         ['http'] = 'http',
--     },
-- })
--
-- now(function()
--     --     require('mini.notify').setup({ config = { border = 'double' } })
--     --     vim.notify = require('mini.notify').make_notify()
-- end)
--
-- now(function()
--     add('folke/snacks.nvim')
--     local function term_nav(dir)
--         ---@param self snacks.terminal
--         return function(self)
--             if self:is_floating() then
--                 return '<C-W>' .. dir
--             else
--                 vim.schedule(function() vim.cmd.wincmd(dir) end)
--             end
--         end
--     end
--     require('snacks').setup({
--         notifier = {
--             timeout = 3000,
--         },
--         styles = {
--             notification = {
--                 wo = { wrap = true }, -- Wrap notifications
--             },
--         },
--         terminal = {
--             win = {
--                 keys = {
--                     nav_h = { '<C-W>h', term_nav('h'), desc = 'Go to Left Window', mode = 't' },
--                     nav_j = { '<C-W>j', term_nav('j'), desc = 'Go to Lower Window', mode = 't' },
--                     nav_k = { '<C-W>k', term_nav('k'), desc = 'Go to Upper Window', mode = 't' },
--                     nav_l = { '<C-W>l', term_nav('l'), desc = 'Go to Right Window', mode = 't' },
--                     hide = { '<c-\\>', function(self) self:hide() end, mode = 't' },
--                 },
--             },
--         },
--     })
--
--     vim.api.nvim_create_autocmd('User', {
--         pattern = 'MiniFilesActionRename',
--         callback = function(event) require('snacks').rename.on_rename_file(event.data.from, event.data.to) end,
--     })
--
--     vim.keymap.set('n', '<c-\\>', function() require('snacks').terminal.toggle() end)
--     vim.keymap.set('n', '<leader>ns', function() Snacks.notifier.show_history() end, { desc = 'Show All Notifications (history)' })
--     vim.keymap.set('n', '<leader>nd', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })
--     vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
--     vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })
--
--     vim.print = require('snacks').debug.inspect
-- end)
--
-- later(function() require('mini.extra').setup() end) -- pickers, hipatterns, textobjects used by other mini plugins
-- later(function()
--     require('mini.basics').setup({
--         options = {
--             -- managed in options.lua
--             basic = false, -- Basic options ('number', 'ignorecase', and many more)
--             extra_ui = false, -- Extra UI features ('winblend', 'cmdheight=0', ...)
--             win_borders = 'default',
--         },
--         mappings = {
--             basic = true, -- Basic mappings (better 'jk', save with Ctrl+S, ...)
--             option_toggle_prefix = [[\]], -- Prefix for mappings that toggle common options ('wrap', 'spell', ...). Empty string to disable
--         },
--         autocommands = {
--             basic = true, -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
--             relnum_in_visual_mode = true, -- Set 'relativenumber' only in linewise and blockwise Visual mode
--         },
--     })
-- end)
--
-- later(function()
--     add('windwp/nvim-autopairs')
--     require('nvim-autopairs').setup({
--         check_ts = true, -- use treesitter
--         ts_config = {
--             java = false, -- apparently you should disable this for java
--         },
--         fast_wrap = {}, -- press <M-e> to close a pair
--     })
-- end)
--
-- later(function() require('mini.align').setup() end)
--
-- later(function()
--     require('mini.bracketed').setup({
--         -- First-level elements are tables describing behavior of a target:
--         --
--         -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
--         --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
--         --   Supply empty string `''` to not create mappings.
--         --
--         -- - <options> - table overriding target options.
--         --
--         -- See `:h MiniBracketed.config` for more info.
--
--         buffer = { suffix = 'b', options = {} },
--         comment = { suffix = 'c', options = {} },
--         conflict = { suffix = 'x', options = {} },
--         diagnostic = { suffix = '', options = {} }, -- managed myself
--         file = { suffix = '', options = {} }, -- don't need
--         indent = { suffix = '', options = {} }, -- don't need
--         jump = { suffix = 'j', options = {} },
--         location = { suffix = 'l', options = {} },
--         oldfile = { suffix = '', options = {} }, -- don't need
--         quickfix = { suffix = 'q', options = {} },
--         treesitter = { suffix = 't', options = {} },
--         undo = { suffix = 'u', options = {} },
--         window = { suffix = '', options = {} }, -- don't need
--         yank = { suffix = 'y', options = {} },
--     })
-- end)
--
-- later(function() require('mini.git').setup() end)
-- later(function()
--     require('mini.diff').setup({
--         view = { style = 'sign' },
--     })
-- end)
--
-- later(function() require('mini.bufremove').setup() end)
--
-- later(function()
--     local miniclue = require('mini.clue')
--   --stylua: ignore
--   miniclue.setup({
--     clues = {
--       Config.leader_group_clues,
--       miniclue.gen_clues.builtin_completion(),
--       miniclue.gen_clues.g(),
--       miniclue.gen_clues.marks(),
--       miniclue.gen_clues.registers(),
--       miniclue.gen_clues.windows({ submode_resize = true }),
--       miniclue.gen_clues.z(),
--     },
--     triggers = {
--       { mode = 'n', keys = '<Leader>' }, -- Leader triggers
--       { mode = 'x', keys = '<Leader>' },
--       { mode = 'n', keys = [[\]] },      -- mini.basics
--       { mode = 'n', keys = '[' },        -- mini.bracketed
--       { mode = 'n', keys = ']' },
--       { mode = 'x', keys = '[' },
--       { mode = 'x', keys = ']' },
--       { mode = 'i', keys = '<C-x>' },    -- Built-in completion
--       { mode = 'n', keys = 'g' },        -- `g` key
--       { mode = 'x', keys = 'g' },
--       { mode = 'n', keys = "'" },        -- Marks
--       { mode = 'n', keys = '`' },
--       { mode = 'x', keys = "'" },
--       { mode = 'x', keys = '`' },
--       { mode = 'n', keys = '"' },        -- Registers
--       { mode = 'x', keys = '"' },
--       { mode = 'i', keys = '<C-r>' },
--       { mode = 'c', keys = '<C-r>' },
--       { mode = 'n', keys = '<C-w>' },    -- Window commands
--       { mode = 'n', keys = 'z' },        -- `z` key
--       { mode = 'x', keys = 'z' },
--     },
--     window = { config = { border = 'double' } },
--   })
-- end)
--
-- later(function()
--     add({
--         source = 'nvim-neotest/neotest',
--         depends = {
--             'nvim-neotest/nvim-nio',
--             'nvim-lua/plenary.nvim',
--             -- 'antoinemadec/FixCursorHold.nvim',
--             -- 'nvim-treesitter/nvim-treesitter',
--         },
--     })
--
--     add('nvim-neotest/neotest-python')
--     add('fredrikaverpil/neotest-golang')
--
--     require('neotest').setup({
--         adapters = {
--             require('neotest-python')({
--                 -- dap = { justMyCode = false },
--             }),
--         },
--     })
-- end)
--
-- later(function()
--     add({
--         source = 'mfussenegger/nvim-dap',
--         depends = { 'rcarriga/nvim-dap-ui', 'theHamsta/nvim-dap-virtual-text', 'nvim-neotest/nvim-nio', 'mfussenegger/nvim-dap-python' },
--     })
--     require('nvim-dap-virtual-text').setup()
--     require('dap-python').setup(require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python')
--     local dap = require('dap')
--     local dapui = require('dapui')
--     dapui.setup()
--     dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
--     dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
--     dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
-- end)
--
-- later(function()
--     add({
--         source = 'kristijanhusak/vim-dadbod-ui',
--         depends = {
--             'tpope/vim-dadbod',
--             'kristijanhusak/vim-dadbod-completion',
--         },
--     })
--
--     local data_path = vim.fn.stdpath('data')
--
--     vim.g.db_ui_auto_execute_table_helpers = 1
--     vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
--     vim.g.db_ui_show_database_icon = true
--     vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
--     vim.g.db_ui_use_nerd_fonts = true
--     vim.g.db_ui_use_nvim_notify = true
--
--     local ok, cmp = pcall(require, 'cmp')
--     if ok then
--         cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
--             sources = {
--                 { name = 'vim-dadbod-completion' },
--                 { name = 'buffer' },
--             },
--         })
--     end
-- end)
--
-- later(function()
--     add('mistweaverco/kulala.nvim')
--     require('kulala').setup()
-- end)
--
-- later(function()
--     add({ source = 'calops/hmts.nvim', checkout = 'v1.2.4', monitor = 'HEAD' }) --
-- end)
--
-- later(function() require('mini.visits').setup() end)
--
--
-- later(function()
--     add({ source = 'epwalsh/obsidian.nvim', depends = { 'nvim-lua/plenary.nvim' } })
--     require('obsidian').setup({
--
--         workspaces = {
--             { name = 'vault', path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault' },
--         },
--     })
-- end)
--
-- -- TODO: heirline.nvim
-- -- TODO: ufo.nvim
-- -- TODO: smart-splits?
-- -- TODO: gitsigns?
