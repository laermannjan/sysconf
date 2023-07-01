-- LunarVim builtin options
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- general
lvim.log.level = "info"
lvim.format_on_save.enabled = true
lvim.builtin.breadcrumbs.active = true


-- (Neo)vim options
-- line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in a file is converted to.
vim.opt.shiftwidth = 4 -- Number of spaces to use for (auto)indenting.
vim.opt.smarttab = true -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
vim.opt.expandtab = true -- in insert mode convert a <Tab> press to spaces
vim.opt.autoindent = true -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
vim.opt.smartindent = true --  adjust indentation based on syntax TODO: review tpope/vim-sleuth.vim for an automated supposedly better indentation experience
-- vim.opt.showtabline = 4 -- show tab line? 0: never, 1: if #tabs >= 2, 2: always -- disable, for plugin
vim.opt.textwidth = 120 -- max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width (might be overridden in ftplugins)

-- line wrapping
vim.opt.wrap = false -- disable line wrapping
vim.opt.breakindent = true -- only matters if `wrap = true`; wrapped line will be equally indented if true

-- appearance
vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.termguicolors = true -- enable 24bit colors when running in terminal
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present
vim.opt.syntax = "enable" -- syntax highlighting
vim.opt.scrolloff = 15 -- minimum number of lines above/below cursor before scrolling starts

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- word motions
vim.opt.iskeyword:append("-") -- consider string-string as whole word

-- search results & highlighting
vim.opt.ignorecase = true -- ignore character case when searching with /, ? or using commands n, N, and some more
vim.opt.smartcase = true -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
vim.opt.hlsearch = true -- keep search result highlighted after pressing <CR>
vim.opt.incsearch = true -- search and show results while typing query
vim.opt.inccommand = "split" -- show effects of command within the screen an partially those that will happen off-screen in a preview window

-- usability
vim.opt.mouse = "a" -- full mouse support
vim.opt.hidden = true -- buffers can become hidden - allow to leave a buffer without saving it to disk
vim.opt.clipboard = "unnamedplus" -- unify clipboards between vim and system

-- TODO: I'd rather change to a projects root dir instead, maybe use something vim-rooter
-- vim.opt.autochdir = true -- change working directory when opening new files / changing buffers -> MIGHT BRICK SOME PLUGINS

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- auto-complete
-- Set completeopt to have a better completion experienc
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt = "menuone"

-- Note: Lvim handles this nicely
-- vim.opt.updatetime = 200 -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
-- vim.opt.timeoutlen = 1000 -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

vim.opt.swapfile = false -- I like to live dangerously - and scream at myself when I edit the same file from different places
vim.opt.undofile = true -- persist the changes I make to my files in `:help undodir` so I can revert after restarts

vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- Don't put double spaces after . (period)

-- vim.opt.shortmess:append("c") -- avoid showing extra messages when using completion
-- vim.opt.showmode = false

-- Note: Lunarvim covers this already
-- -- Highlight what I've just yanked
-- vim.cmd([[
--   augroup YankHighlight
--     autocmd!
--     autocmd TextYankPost * silent! lua vim.highlight.on_yank()
--   augroup end
-- ]])
