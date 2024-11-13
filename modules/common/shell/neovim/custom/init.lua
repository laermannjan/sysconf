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

-- now(function()  end)
vim.filetype.add({
    extension = {
        ['http'] = 'http',
    },
})

now(function()
    -- vim.cmd('colorscheme randomhue')

    -- require('mini.hues').setup({
    --     accent = 'bg',
    --     background = '#14252f',
    --     foreground = '#c1c8cc',
    --     n_hues = 8,
    --     plugins = {
    --         default = true,
    --     },
    --     saturation = 'mediumhigh',
    -- })

    add('folke/tokyonight.nvim')
    require('tokyonight').setup({ style = 'night' })
    vim.cmd('colorscheme tokyonight')
end)

now(function()
    --     require('mini.notify').setup({ config = { border = 'double' } })
    --     vim.notify = require('mini.notify').make_notify()
end)

now(function()
    add('folke/snacks.nvim')
    require('snacks').setup()

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event) require('snacks').rename.on_rename_file(event.data.from, event.data.to) end,
    })

    vim.keymap.set('n', '<c-\\>', function() require('snacks').terminal.toggle() end)
end)

now(function() require('mini.statusline').setup() end)

now(function()
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
    later(MiniIcons.tweak_lsp_kind)
end)

now(function() source('plugins/nvim-lspconfig.lua') end)

later(function() require('mini.extra').setup() end) -- pickers, hipatterns, textobjects used by other mini plugins
later(function()
    require('mini.basics').setup({
        options = {
            -- managed in options.lua
            basic = false, -- Basic options ('number', 'ignorecase', and many more)
            extra_ui = false, -- Extra UI features ('winblend', 'cmdheight=0', ...)
            win_borders = 'default',
        },
        mappings = {
            basic = true, -- Basic mappings (better 'jk', save with Ctrl+S, ...)
            option_toggle_prefix = [[\]], -- Prefix for mappings that toggle common options ('wrap', 'spell', ...). Empty string to disable
        },
        autocommands = {
            basic = true, -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
            relnum_in_visual_mode = true, -- Set 'relativenumber' only in linewise and blockwise Visual mode
        },
    })
end)

later(function() source('plugins/nvim-treesitter.lua') end)

later(function()
    add('stevearc/conform.nvim')
    require('conform').setup({
        formatters = {
            kulala = {
                command = 'kulala-fmt',
                args = { '$FILENAME' },
                stdin = false,
            },
        },
        -- Map of filetype to formatters
        formatters_by_ft = {
            lua = { 'stylua' },
            javascript = { 'prettier' },
            json = { 'prettier' },
            go = { 'goimports', 'gofumpt' },
            nix = { 'nixfmt' },
            http = { 'kulala' },
        },
        format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_format = 'fallback',
            timeout_ms = 500,
        },
        default_format_opts = {
            lsp_format = 'fallback',
        },
    })
end)

later(function()
    add('mfussenegger/nvim-lint')
    source('plugins/nvim-lint.lua')
end)

later(function() require('mini.comment').setup() end)
later(function() require('mini.operators').setup() end)

later(function()
    local ts_input = require('mini.surround').gen_spec.input.treesitter
    require('mini.surround').setup({
        suffix_last = 'p', -- instead of default l
        custom_surroundings = {
            f = { input = ts_input({ outer = '@call.outer', inner = '@call.inner' }) },
            F = { input = ts_input({ outer = '@function.outer', inner = '@function.inner' }) },
        },
    })
end)

later(function()
    local ai = require('mini.ai')
    ai.setup({
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            ['='] = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.rhs' }),
        },
    })
end)

later(function()
    add('windwp/nvim-autopairs')
    require('nvim-autopairs').setup({
        check_ts = true, -- use treesitter
        ts_config = {
            java = false, -- apparently you should disable this for java
        },
        fast_wrap = {}, -- press <M-e> to close a pair
    })
end)

later(function() require('mini.align').setup() end)

later(function()
    add({ source = 'folke/todo-comments.nvim', depends = { 'nvim-lua/plenary.nvim' } })
    require('todo-comments').setup()
    vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' })
    vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' })
end)

later(function()
    require('mini.pick').setup()
    vim.ui.select = MiniPick.ui_select
end)

later(function()
    require('mini.files').setup({
        windows = { preview = true },
        mappings = {
            go_in = '',
            go_in_plus = '<cr>',
            go_out = '',
            go_out_plus = '<bs>',
            reset = '',
            close = '<esc>',
        },
    })
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
            MiniFiles.set_bookmark('d', vim.fn.expand('~/dev'), { desc = '~/dev' })
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

later(function()
    require('mini.bracketed').setup({
        -- First-level elements are tables describing behavior of a target:
        --
        -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
        --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
        --   Supply empty string `''` to not create mappings.
        --
        -- - <options> - table overriding target options.
        --
        -- See `:h MiniBracketed.config` for more info.

        buffer = { suffix = 'b', options = {} },
        comment = { suffix = 'c', options = {} },
        conflict = { suffix = 'x', options = {} },
        diagnostic = { suffix = '', options = {} }, -- managed myself
        file = { suffix = '', options = {} }, -- don't need
        indent = { suffix = '', options = {} }, -- don't need
        jump = { suffix = 'j', options = {} },
        location = { suffix = 'l', options = {} },
        oldfile = { suffix = '', options = {} }, -- don't need
        quickfix = { suffix = 'q', options = {} },
        treesitter = { suffix = 't', options = {} },
        undo = { suffix = 'u', options = {} },
        window = { suffix = '', options = {} }, -- don't need
        yank = { suffix = 'y', options = {} },
    })
end)

later(function()
    require('mini.jump').setup() -- fFtT over multiple lines and repeatable by pressign fFtT again
end)

later(function()
    require('mini.jump2d').setup() -- jump anywhere, hit <cr> to start
end)

later(function()
    require('mini.splitjoin').setup() -- gS to toggle splitting/joining arguments/lists over lines
end)

later(function()
    require('mini.trailspace').setup() -- visualize trailing whitespace, remove with `:lua MiniTrailspace.trim()`
end)

later(function() require('mini.git').setup() end)
later(function()
    require('mini.diff').setup({
        view = { style = 'sign' },
    })
end)

later(function() require('mini.bufremove').setup() end)

later(function()
    local miniclue = require('mini.clue')
  --stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = 'g' },        -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'n', keys = 'z' },        -- `z` key
      { mode = 'x', keys = 'z' },
    },
    window = { config = { border = 'double' } },
  })
end)

later(function()
    add({
        source = 'nvim-neotest/neotest',
        depends = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            -- 'antoinemadec/FixCursorHold.nvim',
            -- 'nvim-treesitter/nvim-treesitter',
        },
    })

    add('nvim-neotest/neotest-python')
    add('fredrikaverpil/neotest-golang')

    require('neotest').setup({
        adapters = {
            require('neotest-python')({
                -- dap = { justMyCode = false },
            }),
        },
    })
end)

later(function()
    add({
        source = 'kristijanhusak/vim-dadbod-ui',
        depends = {
            'tpope/vim-dadbod',
            'kristijanhusak/vim-dadbod-completion',
        },
    })

    local data_path = vim.fn.stdpath('data')

    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true

    local ok, cmp = pcall(require, 'cmp')
    if ok then
        cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
            sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
            },
        })
    end
end)

later(function()
    add('mistweaverco/kulala.nvim')
    require('kulala').setup()
end)

later(function()
    add({ source = 'calops/hmts.nvim', checkout = 'v1.2.4', monitor = 'HEAD' }) --
end)

later(function() require('mini.visits').setup() end)

now(function()
    add('MeanderingProgrammer/render-markdown.nvim')
    require('render-markdown').setup()
    vim.keymap.set('n', '\\m', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown renderer' })
end)

later(function()
    add({ source = 'epwalsh/obsidian.nvim', depends = { 'nvim-lua/plenary.nvim' } })
    require('obsidian').setup({

        workspaces = {
            { name = 'vault', path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault' },
        },
    })
end)

-- TODO: heirline.nvim
-- TODO: ufo.nvim
-- TODO: smart-splits?
-- TODO: gitsigns?
