vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4        -- Number of spaces that a <Tab> in a file is converted to.
opt.shiftwidth = 4     -- Number of spaces to use for (auto)indenting.
opt.shiftround = true  -- round indent to multiple of shiftwidth. > and < will move text to the next multiple of shiftwidth, instead of a fixed value
opt.smarttab = true    -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
opt.expandtab = true   -- in insert mode convert a <Tab> press to spaces
opt.autoindent = true  -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
opt.smartindent = true --  adjust indentation based on syntax
-- opt.showtabline = 4 -- show tab line? 0: never, 1: if #tabs >= 2, 2: always -- disable, for plugin
opt.textwidth = 128    -- max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width (might be overridden in ftplugins)

-- line wrapping
opt.wrap = false              -- disable line wrapping
opt.breakindent = true        -- only matters if `wrap = true`; wrapped line will be equally indented if true

opt.cursorline = true         -- highlight the current cursor line
opt.termguicolors = true      -- enable 24bit colors when running in terminal
opt.signcolumn =
"yes"                         -- show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present
opt.scrolloff = 8             -- minimum number of lines above/below cursor before scrolling starts
opt.cmdheight = 1
opt.showmode = false          -- Dont show mode since we have a statusline

opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- search results & highlighting
opt.ignorecase = true -- ignore character case when searching with /, ? or using commands n, N, and some more
opt.smartcase = true  -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
opt.hlsearch = true   -- keep search result highlighted after pressing <CR>
opt.incsearch = true  -- search and show results while typing query
opt.inccommand =
"split"               -- show effects of command within the screen an partially those that will happen off-screen in a preview window

-- usability
opt.mouse = "a"      -- full mouse support
-- opt.laststatus = 3
opt.updatetime = 50  -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
opt.timeoutlen = 500 -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

opt.swapfile = false -- I like to live dangerously - and scream at myself when I edit the same file from different places
opt.undofile = true  -- persist the changes I make to my files in `:help undodir` so I can revert after restarts
opt.undolevels = 10000

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.autowrite = true -- Auto save a buffer when jumping away from it
opt.conceallevel = 3 -- conceal all items that have a conceal tag
opt.confirm = true   -- Confirm to save changes before exiting modified buffer

opt.pumheight = 15   -- number of items to show in a popup menu (autocompletion)
opt.pumblend = 18    -- transparency value for that menu (0 opaque, 100 transparent)
