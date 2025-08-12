-- 0. CHECKS ===========================================================================================================

-- `vim.pack` introduced in nvim 0.12
if vim.fn.has 'nvim-0.12' == 0 then error '[ERROR] Need at least nvim 0.12' end

-- 1. OPTIONS ==========================================================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.smartindent = true -- indent new line based on key words 'cinwords'
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- size of indent
vim.opt.tabstop = 4 -- number of spaces tabs count for
vim.opt.smarttab = true -- a <Tab> in front of a line inserts blanks according to 'shiftwidth'
vim.opt.shiftround = true -- indent to next multiple of 'shiftwidth'
vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true -- disable highlight with `:noh`, also mapped to <ESC>
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.winborder = 'single'
vim.opt.laststatus = 3 -- one status line for the active window

vim.opt.list = true -- show invisible characters (e.g. trailing spaces)
vim.opt.listchars = { trail = '␣', nbsp = '␣', tab = '> ', extends = '…', precedes = '…' }

vim.opt.clipboard = 'unnamedplus'
vim.opt.confirm = true
vim.opt.mouse = 'a'
vim.opt.scrolloff = 8

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.exrc = true -- allows project local neovim config `:h project-config`

local group = vim.api.nvim_create_augroup('lrmn', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    desc = "Ensure proper 'formatoptions'",
    callback = function()
        -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
        -- If we don't do this on `FileType`, this keeps reappearing due to being set in
        -- filetype plugins.
        vim.cmd 'setlocal formatoptions-=c formatoptions-=o'
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    desc = 'Highlight on yank',
    callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    desc = 'Open file at last location',
    callback = function(event)
        local exclude = { 'gitcommit' }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    desc = 'Close Neovim when only codecompanion window remains',
    -- pattern = "*",
    callback = function()
        local quit_filetypes = { 'codecompanion' }
        -- Use vim.schedule to ensure the window count is accurate after the close event
        vim.schedule(function()
            -- Filter to only regular windows (not floating/popup windows)
            local regular_wins = vim.tbl_filter(function(win)
                local config = vim.api.nvim_win_get_config(win)
                return config.relative == ''
            end, vim.api.nvim_list_wins())

            local win_count = #regular_wins

            if win_count == 1 then
                local current_win = vim.api.nvim_get_current_win()
                local buf = vim.api.nvim_win_get_buf(current_win)
                local filetype = vim.bo[buf].filetype

                if vim.tbl_contains(quit_filetypes, filetype) then vim.cmd 'quit' end
            end
        end)
    end,
})

-- 2. PLUGINS ==========================================================================================================

vim.api.nvim_create_autocmd('PackChanged', {
    group = group,
    desc = 'Update Treesitter parsers when the nvim-treesitter plugin was updated (via vim.pack)',
    callback = function(ev)
        if
            ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' --[[or ev.data.kind == "install"]]
        then
            local ok, _ = pcall(function() require('nvim-treesitter').update 'all' end) -- 'all' updates everything installed
            if not ok then vim.notify '[ERROR] Failed to update nvim-treesitter parsers' end
        end
    end,
})

vim.pack.add {
    { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- dep from: codecompanion, todo-comments
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/folke/lazydev.nvim' },
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/folke/todo-comments.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/rebelot/heirline.nvim' },
    { src = 'https://github.com/Zeioth/heirline-components.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
    { src = 'https://github.com/cbochs/grapple.nvim' },
    { src = 'https://github.com/echasnovski/mini.files' },
    { src = 'https://github.com/echasnovski/mini.icons' },
    { src = 'https://github.com/echasnovski/mini.surround' },
    { src = 'https://github.com/zbirenbaum/copilot.lua' },
    { src = 'https://github.com/olimorris/codecompanion.nvim' },
}

-- colorscheme ---------------------------------------------------------------------------------------------------------

require('vague').setup { transparent = false }
vim.cmd 'colorscheme vague'
-- vim.cmd(":hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#212121' }) -- 'dim' inactive windows

-- treesitter ----------------------------------------------------------------------------------------------------------

-- WARN: tree-sitter-cli needs to be installed, not just tree-sitter (the lib)
-- This is likely the problem when things hang at 'Compiling parser ...'
-- require('nvim-treesitter').install 'stable' -- TODO: likely should be 'stable' or 'core'. But every parser is currently unstable on main; https://github.com/nvim-treesitter/nvim-treesitter/issues/4767

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    desc = 'Enable treesitter highlighting, indents, and folds',
    callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)

        if not lang then return end

        if not vim.treesitter.language.add(lang) then
            if require('nvim-treesitter').install(lang):wait(5000) ~= 0 then return end
            vim.treesitter.language.add(lang)
        end

        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- lsp -----------------------------------------------------------------------------------------------------------------

require('mason').setup()
require('mason-lspconfig').setup() -- keeping this for auto enabling lsps

-- auto installer

local mr = require 'mason-registry'
mr.refresh(function()
    local ensure_installed = {
        -- lua
        'lua-language-server',
        'stylua',
        -- python
        'basedpyright',
        'ty',
        'ruff',
        -- "pyrefly",
        -- go
        'gopls',
        'goimports',
        'gofumpt',
        'delve',
        -- zig
        'zls',
        -- rust
        'rust-analyzer',
        'rustfmt', -- NOTE: deprecated, should be shipped via rustup
        'codelldb',
        -- typst
        'tinymist',
        -- sql
        'sqlfluff',
    }
    for _, tool in ipairs(ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
    end
end)

-- proper lua_ls setup to edit neovim config (and other libs)
require('lazydev').setup {
    library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = '${3rd}/love2d/library', words = { 'love' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
    },
}

require('conform').setup {
    formatters_by_ft = {
        -- python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
        lua = { 'stylua' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        go = { 'goimports', 'gofumpt' },
        nix = { 'nixfmt' },
        http = { 'kulala-fmt' },
        just = { 'just' },
        -- sql = { 'sql_formatter' },
        sql = { 'sqlfluff' },
        yaml = { 'yamlfmt' },
        rust = { 'rustfmt' },
    },
    default_format_opts = {
        lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
        if vim.g.autoformat ~= false then
            return {
                -- I recommend these options. See :help conform.format for details.
                lsp_format = 'fallback',
                timeout_ms = 500,
            }
        end
    end,
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- use conform with 'gq'

-- Folke --------------------------------------------------------------------------------------------------------------

require('snacks').setup {
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = { ui_select = true },
    statuscolumn = { enabled = true },
    scope = { enabled = true },
    words = { enabled = true },
}

require('which-key').setup { preset = 'helix', show_help = false }
require('todo-comments').setup()

-- Statusline ---------------------------------------------------------------------------------------------------------

local heirline = require 'heirline'
local heirline_components = require 'heirline-components.all'
heirline_components.init.subscribe_to_events()
heirline.load_colors(heirline_components.hl.get_colors())
heirline.setup {
    statusline = {
        hl = { fg = 'fg', bg = 'bg' },
        heirline_components.component.mode(),
        heirline_components.component.git_branch(),
        heirline_components.component.file_info(),
        heirline_components.component.git_diff(),
        heirline_components.component.diagnostics(),
        heirline_components.component.fill(),
        heirline_components.component.file_info { filename = { modify = ':~:.' }, filetype = false },
        heirline_components.component.fill(),
        heirline_components.component.lsp(),
        heirline_components.component.nav(),
        heirline_components.component.mode { surround = { separator = 'right' } },
    },
}

-- Statusline ---------------------------------------------------------------------------------------------------------

require('blink.cmp').setup {
    sources = { default = { 'lsp', 'path' } },
    signature = { enabled = true },
    completion = {
        keyword = { range = 'prefix' },
        list = { selection = { preselect = false, auto_insert = true } },
        accept = { auto_brackets = { enabled = true } },
        menu = { draw = { treesitter = { 'lsp' } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
    },
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
}

-- Other --------------------------------------------------------------------------------------------------------------

require('mini.icons').setup {
    file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
    },
    filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
    },
}
MiniIcons.mock_nvim_web_devicons()

require('mini.files').setup {
    windows = { preview = true, width_preview = 80 },
    mappings = {
        go_in = '',
        go_in_plus = '<cr>',
        go_out = '',
        go_out_plus = '<bs>',
        reset = '',
    },
}

require('mini.surround').setup { suffix_last = 'p' }

require('gitsigns').setup {
    attach_to_untracked = true,
    current_line_blame = true,
}

require('grapple').setup { scope = 'git' }

-- code companion ------------------------------------------------------------------------------------------------------

-- only use this to get the token
require('copilot').setup {
    panel = { enabled = false },
    suggestion = { enabled = false },
}
require('codecompanion').setup {
    strategies = {
        chat = {
            adapter = { name = 'copilot', model = 'claude-sonnet-4' },
        },
        inline = {
            adapter = { name = 'copilot', model = 'claude-sonnet-4' },
        },
        cmd = {
            adapter = { name = 'copilot', model = 'claude-sonnet-4' },
        },
    },
}
vim.keymap.set('ca', 'cc', 'CodeCompanion')
vim.keymap.set('ca', 'Cc', 'CodeCompanion')
vim.keymap.set('ca', 'CC', 'CodeCompanion')

-- 3. KEYMAPS ============================================================:==============================================

vim.keymap.set('ca', 'W', 'w')
vim.keymap.set('ca', 'Wq', 'wq')
vim.keymap.set('ca', 'Wq!', 'wq!')
vim.keymap.set('ca', 'WQ!', 'wq!')
vim.keymap.set('ca', 'Q', 'q')
vim.keymap.set('ca', 'Q!', 'q!')

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', '<S-h>', '^')
vim.keymap.set('n', '<S-l>', 'g_')

vim.keymap.set({ 'n', 'i', 's' }, '<Esc>', '<Esc>:noh<CR>')

vim.keymap.set('n', '<leader>ve', ':e $MYVIMRC<CR>', { desc = 'edit init.lua' })
vim.keymap.set('n', '<leader>vr', ':source $MYVIMRC<CR>', { desc = 'reload init.lua' })

vim.keymap.set({ 'n' }, '<leader>/', function() Snacks.picker.grep() end, { desc = 'Search (workspace)' })
vim.keymap.set({ 'n' }, '<leader>?', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
-- vim.keymap.set({'n'}, '<leader>D', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics (open files)' })
vim.keymap.set({ 'n' }, '<leader>f', function() Snacks.picker.smart() end, { desc = 'Files' })
vim.keymap.set({ 'n' }, '<leader>F', function() Snacks.picker.files { hidden = true, ignored = true } end, { desc = 'Files (workspace)' })
vim.keymap.set({ 'n' }, '<leader>h', function() Snacks.picker.help() end, { desc = 'Help' })
vim.keymap.set({ 'n' }, '<leader>s', function() Snacks.picker.lsp_symbols() end, { desc = 'Symbols' })
vim.keymap.set({ 'n' }, '<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Symbols (workspace TODO)' })
vim.keymap.set({ 'n' }, '<leader>p', function() Snacks.picker.projects() end, { desc = 'Projects' })
vim.keymap.set({ 'n' }, '<leader>P', function() Snacks.picker() end, { desc = 'Pickers' })
vim.keymap.set({ 'n', 'x' }, '<leader>.', function() Snacks.picker.grep_word() end, { desc = 'Grep (word or selection)' })
vim.keymap.set({ 'n' }, '<leader>\\', function() Snacks.picker.resume() end, { desc = 'Resume' })

vim.keymap.set({ 'n' }, 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Code Actions' })
vim.keymap.set({ 'n' }, 'gr', function() Snacks.picker.lsp_references { include_declaration = false } end, { desc = 'References' })
vim.keymap.set({ 'n' }, 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Definition' })
vim.keymap.set({ 'n' }, 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Declaration' })
vim.keymap.set({ 'n' }, 'gi', function() Snacks.picker.lsp_implementations() end, { desc = 'Implementation' })
vim.keymap.set({ 'n' }, 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Type definition' })
vim.keymap.set({ 'n' }, 'gF', function() Snacks.gitbrowse() end, { desc = 'Open Git Remote URL' })

vim.keymap.set({ 'n' }, '<leader>g', function() Snacks.lazygit() end, { desc = 'Lazygit' })
vim.keymap.set({ 'n' }, '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notifications' })

vim.keymap.set({ 'n' }, '<leader>e', function()
    if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end
end, { desc = 'Explorer' })

vim.keymap.set({ 'n' }, '<Space><Space><Space>', ':Grapple toggle_tags<CR>', { desc = 'show tagged files' })
vim.keymap.set({ 'n' }, '<Space><Space>t', ':Grapple tag<CR>', { desc = 'tag file' })
vim.keymap.set({ 'n' }, '<Space><Space>1', ':Grapple select index=1<CR>', { desc = 'open tagged file' })
vim.keymap.set({ 'n' }, '<Space><Space>2', ':Grapple select index=2<CR>', { desc = 'open tagged file' })
vim.keymap.set({ 'n' }, '<Space><Space>3', ':Grapple select index=3<CR>', { desc = 'open tagged file' })
vim.keymap.set({ 'n' }, '<Space><Space>4', ':Grapple select index=4<CR>', { desc = 'open tagged file' })
vim.keymap.set({ 'n' }, '<Space><Space>5', ':Grapple select index=5<CR>', { desc = 'open tagged file' })

vim.keymap.set({ 'n' }, '<leader>a', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat buffer' })
vim.keymap.set({ 'v' }, '<leader>a', ':CodeCompanionChat Add<CR>', { desc = 'Add code to AI chat buffer' })
vim.keymap.set({ 'n', 'v' }, '<localleader>a', ':CodeCompanionActions<CR>', { desc = 'Open AI action selection' })

-- Toggles -------------------------------------------------------------------------------------------------------------

require('which-key').add { { '<leader>u', group = 'Toggles' } }
require('which-key').add { { '<leader>v', group = '(neo)vim' } }
require('which-key').add { { '<Space><Space>', group = 'Grapple' } }
Snacks.toggle.option('spell'):map '<leader>us'
Snacks.toggle.option('wrap'):map '<leader>uw'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('relativenumber'):map '<leader>uL'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.inlay_hints():map '<leader>uh'
Snacks.toggle.indent():map '<leader>ui'
Snacks.toggle
    .new({
        name = 'autoformat',
        get = function() return vim.g.autoformat ~= false end,
        set = function(state) vim.g.autoformat = state end,
    })
    :map '<leader>uf'
