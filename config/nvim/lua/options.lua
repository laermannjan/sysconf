--stylua: ignore start
-- General ====================================================================
-- vim.o.backup       = false          -- Don't store backup
-- vim.o.writebackup  = false          -- Don't store backup
vim.o.mouse        = 'a'            -- Enable mouse
vim.o.mousescroll  = 'ver:3,hor:6'  -- Scroll 3 lines vertically and 6 horizontally
vim.o.switchbuf    = 'usetab'       -- Use already opened buffers when switching
-- vim.o.swapfile = false              -- I like to live dangerously - and scream at myself when I edit the same file from different places
vim.o.undofile     = true           -- Enable persistent undo
-- vim.o.undolevels   = 10000          -- Maximum number of changes that can be undone (default 1000)
vim.o.clipboard    = "unnamedplus"  -- use system clipboard as default register
vim.o.updatetime   = 50             -- Time in milliseconds to wait for swap file write (also used for completions)
vim.o.timeoutlen   = 500            -- Time in milliseconds to wait for mapped sequence to complete
-- vim.o.fileencoding = "utf-8"        -- Files will be (converted and) written in UTF-8
-- vim.o.autowrite = true              -- Auto save a buffer when jumping away from it - use with care when using auto formatting
vim.o.confirm = true                -- Confirm to save changes before exiting modified buffer

vim.o.shada        = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- UI =========================================================================
vim.o.wrap           = false     -- Display long lines as just one line
vim.o.breakindent    = true      -- Indent wrapped lines to match line start
vim.o.colorcolumn    = '+1'      -- Draw colored column one step to the right of desired maximum width
vim.o.cursorline     = true      -- Enable highlighting of the current line
vim.o.laststatus     = 3         -- Always show statusline, but only for current window
vim.o.linebreak      = true      -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true      -- Show helpful character indicators
vim.o.number         = true      -- Show line numbers
-- vim.o.relativenumber = true      -- Show relative line numbers
vim.o.pumblend       = 10        -- Make builtin completion menus slightly transparent
vim.o.pumheight      = 10        -- Make popup menu smaller
vim.o.winblend       = 10	 -- Make floating windows slightly transparent
vim.o.ruler          = false     -- Don't show cursor position
vim.o.shortmess      = 'aoOT' -- Disable certain messages from |ins-completion-menu|
vim.o.showmode       = false     -- Don't show mode in command line
-- vim.o.showtabline    = 2         -- Always show tabline (0:never, 1:only if #tabs > 1, 2:always)
vim.o.signcolumn     = 'yes'     -- Always show signcolumn or it would frequently shift
vim.o.splitbelow     = true      -- Horizontal splits will be below
vim.o.splitright     = true      -- Vertical splits will be to the right
vim.o.termguicolors  = true      -- Enable gui colors
vim.o.winblend       = 10        -- Make floating windows slightly transparent
vim.o.scrolloff      = 8         -- Minimum number of lines above/below cursor before scrolling starts
vim.o.conceallevel   = 2         -- Show concealable text (like markdown lists) as-is
vim.o.completeopt = "menu,menuone,noselect,longest"
vim.o.wildmode = "longest:full,full" -- in ex-mode (:) <tab> completes longest common string and show candidates, when candidates are shown another <tab> cycles through them

vim.o.fillchars = table.concat(
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)
vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
vim.o.cursorlineopt = 'screenline,number' -- Show cursor line only screen line when wrapped
vim.o.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on

if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess:append('C') -- Don't show "Scanning..." messages
  vim.o.splitkeep = 'screen'    -- Reduce scroll during window split
end

-- Colors =====================================================================
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Editing ====================================================================
-- vim.o.autoindent    = true     -- Use auto indent
vim.o.smartindent   = true     -- Make indenting smart
-- vim.opt.cpoptions:append('I')  -- Don't delete indent from autoindent when not typing anything or moving away

vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase    = true     -- Ignore case when searching (use `\C` to force not doing that)
vim.o.smartcase     = true     -- Don't ignore case when searching if pattern has upper case
vim.o.incsearch     = true     -- Show search results while typing
vim.o.hlsearch      = true     -- Show search results even after hitting <CR>
vim.o.tabstop       = 4       -- Negative value to use the same value as shiftwidth
vim.o.expandtab     = true     -- Convert tabs to spaces in insert mode
vim.o.shiftwidth    = 4        -- Use this number of spaces for indentation
vim.o.shiftround    = true     -- Round indent to multiple of shiftwidth when using < and >

vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode

vim.opt.iskeyword:append('-')  -- Treat dash separated words as a word text object

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Spelling ===================================================================
vim.o.spelllang    = 'en_us,de'   -- Define spelling dictionaries
vim.o.spelloptions = 'camel'      -- Treat parts of camelCase words as seprate words
-- vim.opt.complete:append('kspell') -- Add spellcheck options for autocomplete
-- vim.opt.complete:remove('t')      -- Don't use tags for completion

-- vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt' -- Use specific dictionaries

-- Folds ======================================================================
-- vim.o.foldmethod  = 'indent' -- Set 'indent' folding method
-- vim.o.foldlevel   = 3        -- Display all folds except top two
-- vim.o.foldnestmax = 10       -- Create folds only for some number of nested levels
-- vim.g.markdown_folding = 1   -- Use folding by heading in markdown files

if vim.fn.has('nvim-0.10') == 1 then
  vim.o.foldtext = ''        -- Use underlying text with its highlighting
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.completeopt:append('fuzzy') -- Use fuzzy matching for built-in completion
end

-- Custom autocommands ========================================================
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('formatoptions'),
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
  desc = [[Ensure proper 'formatoptions']],
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})


-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

--stylua: ignore end
