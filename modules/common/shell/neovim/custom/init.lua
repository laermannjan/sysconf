-- Initialization =============================================================
pcall(function() vim.loader.enable() end)

-- Define main config table
_G.Config = {
  install_path = vim.fn.stdpath('data') .. '/site/',
  source_path = vim.fn.stdpath('config') .. '/src/',
  -- source_path = vim.fn.expand('%:h') .. '/src/',
}
--------------------
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local mini_path = Config.install_path .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = Config.install_path } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local source = function(path) dofile(Config.source_path .. path) end

-- Options and mappings =====================================================
now(function() source('options.lua') end)
now(function() source('functions.lua') end)
now(function() source('keymaps.lua') end)
-- if vim.g.vscode ~= nil then now(function() source('vscode.lua') end) end

-- Plugins ==================================================================
add({ name = 'mini.nvim' })

now(function() vim.cmd('colorscheme randomhue') end)

now(function()
  require('mini.notify').setup({ config = { border = 'double' } })
  vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.statusline').setup() end)

now(function()
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
    later(MiniIcons.tweak_lsp_kind)
end)


now(function ()
    source('plugins/nvim-lspconfig.lua')
end)


later(function() require('mini.extra').setup() end)  -- pickers, hipatterns, textobjects used by other mini plugins
later(function()
	require('mini.basics').setup({
	  options = {
	    -- managed in options.lua
	    basic = false, -- Basic options ('number', 'ignorecase', and many more)
	    extra_ui = false,  -- Extra UI features ('winblend', 'cmdheight=0', ...)
	    win_borders = 'default',
	  },
	  mappings = {
	    basic = true,  -- Basic mappings (better 'jk', save with Ctrl+S, ...)
	    option_toggle_prefix = [[\]],  -- Prefix for mappings that toggle common options ('wrap', 'spell', ...). Empty string to disable
	  },
	  autocommands = {
	    basic = true,   -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
	    relnum_in_visual_mode = true, -- Set 'relativenumber' only in linewise and blockwise Visual mode
	  },
	})
end)

later(function()
  source('plugins/nvim-treesitter.lua')
end)

later(function() require('mini.comment').setup() end)
later(function() require('mini.operators').setup() end)

later(function()
    local ts_input = require('mini.surround').gen_spec.input.treesitter
    require('mini.surround').setup({
        suffix_last = "p", -- instead of default l
        custom_surroundings = {
            f = { input = ts_input({ outer = '@call.outer', inner = '@call.inner' }) },
            F = { input = ts_input({ outer = '@function.outer', inner = '@function.inner' }) },
        }
    })
end)

later(function()
    local ai = require('mini.ai')
    ai.setup({
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            ["="] = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.rhs' }),
        },
    })
end)

later(function()
   add('windwp/nvim-autopairs')
   require("nvim-autopairs").setup({
        check_ts = true, -- use treesitter
        ts_config = {
            java = false, -- apparently you should disable this for java
        },
        fast_wrap = {}, -- press <M-e> to close a pair
    })
end)

later(function()
    add({ source = 'folke/todo-comments.nvim', depends = { 'nvim-lua/plenary.nvim' } })
    require('todo-comments').setup()
    vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
    vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" }) end)

later(function()
    require('mini.pick').setup()
    vim.ui.select = MiniPick.ui_select
    vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>")
end)

later(function()
  require('mini.files').setup({ windows = { preview = true } })
  local minifiles_augroup = vim.api.nvim_create_augroup('ec-mini-files', {})
  vim.api.nvim_create_autocmd('User', {
    group = minifiles_augroup,
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
  })
  vim.api.nvim_create_autocmd('User', {
    group = minifiles_augroup,
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim', { desc = 'mini.nvim' })
      MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/deps/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
    end,
  })
end)

-- Documentation generator
later(function()
  add('danymat/neogen')
  require('neogen').setup({
    languages = {
      lua = { template = { annotation_convention = 'emmylua' } },
      python = { template = { annotation_convention = 'numpydoc' } },
    },
  })
end)
