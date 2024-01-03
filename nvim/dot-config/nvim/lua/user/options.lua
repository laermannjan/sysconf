vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)
-- tabs & indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in a file is converted to.
vim.opt.shiftwidth = 4 -- Number of spaces to use for (auto)indenting.
vim.opt.shiftround = true -- round indent to multiple of shiftwidth. > and < will move text to the next multiple of shiftwidth, instead of a fixed value
vim.opt.smarttab = true -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
vim.opt.expandtab = true -- in insert mode convert a <Tab> press to spaces
vim.opt.autoindent = true -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
vim.opt.smartindent = true --  adjust indentation based on syntax
-- vim.opt.showtabline = 4 -- show tab line? 0: never, 1: if #tabs >= 2, 2: always -- disable, for plugin
vim.opt.textwidth = 128 -- max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width (might be overridden in ftplugins)

-- line wrapping
vim.opt.wrap = false -- disable line wrapping
vim.opt.breakindent = true -- only matters if `wrap = true`; wrapped line will be equally indented if true

vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.termguicolors = true -- enable 24bit colors when running in terminal
vim.opt.signcolumn = "yes" -- show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present
vim.opt.scrolloff = 8 -- minimum number of lines above/below cursor before scrolling starts
vim.opt.cmdheight = 1
vim.opt.showmode = false -- Dont show mode since we have a statusline

vim.opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- search results & highlighting
-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true -- ignore character case when searching with /, ? or using commands n, N, and some more
vim.opt.smartcase = true -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
vim.opt.hlsearch = true -- keep search result highlighted after pressing <CR>
vim.opt.incsearch = true -- search and show results while typing query
vim.opt.inccommand = "split" -- show effects of command within the screen an partially those that will happen off-screen in a preview window

-- usability
vim.opt.mouse = "a" -- full mouse support
-- opt.laststatus = 3
vim.opt.updatetime = 50 -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
vim.opt.timeoutlen = 500 -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

vim.opt.swapfile = false -- I like to live dangerously - and scream at myself when I edit the same file from different places
vim.opt.undofile = true -- persist the changes I make to my files in `:help undodir` so I can revert after restarts
vim.opt.undolevels = 10000

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.autowrite = true -- Auto save a buffer when jumping away from it
vim.opt.conceallevel = 3 -- conceal all items that have a conceal tag
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer

vim.opt.pumheight = 15 -- number of items to show in a popup menu (autocompletion)
vim.opt.pumblend = 18 -- transparency value for that menu (0 opaque, 100 transparent)

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
