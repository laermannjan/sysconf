local opt = vim.opt

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4 -- Number of spaces that a <Tab> in a file is converted to.
opt.shiftwidth = 4 -- Number of spaces to use for (auto)indenting.
opt.smarttab = true -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
opt.expandtab = true -- in insert mode convert a <Tab> press to spaces
opt.autoindent = true -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
opt.smartindent = true --  adjust indentation based on syntax TODO: review tpope/sleuth.for an automated supposedly better indentation experience
-- opt.showtabline = 4 -- show tab line? 0: never, 1: if #tabs >= 2, 2: always -- disable, for plugin
opt.textwidth = 120 -- max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width (might be overridden in ftplugins)

-- line wrapping
opt.wrap = false -- disable line wrapping
opt.breakindent = true -- only matters if `wrap = true`; wrapped line will be equally indented if true

-- appearance
opt.cursorline = true -- highlight the current cursor line
opt.termguicolors = true -- enable 24bit colors when running in terminal
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present
opt.syntax = "enable" -- syntax highlighting
opt.scrolloff = 15 -- minimum number of lines above/below cursor before scrolling starts
opt.cmdheight = 1

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- word motions
opt.iskeyword:append("-") -- consider string-string as whole word

-- search results & highlighting
opt.ignorecase = true -- ignore character case when searching with /, ? or using commands n, N, and some more
opt.smartcase = true -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
opt.hlsearch = true -- keep search result highlighted after pressing <CR>
opt.incsearch = true -- search and show results while typing query
opt.inccommand = "split" -- show effects of command within the screen an partially those that will happen off-screen in a preview window

-- usability
opt.mouse = "a" -- full mouse support
opt.hidden = true -- buffers can become hidden - allow to leave a buffer without saving it to disk
opt.laststatus = 3
opt.updatetime = 250

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- auto-complete
-- Set completeopt to have a better completion experienc
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
opt.completeopt = "menuone,noinsert"

-- opt.updatetime = 300 -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
-- opt.timeoutlen = 1000 -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

opt.swapfile = false -- I like to live dangerously - and scream at myself when I edit the same file from different places
opt.undofile = true -- persist the changes I make to my files in `:help undodir` so I can revert after restarts

opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- Don't put double spaces after . (period)

-- opt.shortmess:append("c") -- avoid showing extra messages when using completion
-- opt.showmode = false


opt.path:remove("/usr/include")
opt.path:append("**")
opt.wildignorecase = true
opt.wildignore:append("**/node_modules/*")
opt.wildignore:append("**/mypy_cache/*")
opt.wildignore:append("**/.git/*")
