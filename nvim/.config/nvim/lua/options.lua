--           _____            _____          
--          /\    \          /\    \         
--         /::\____\        /::\    \        
--        /:::/    /        \:::\    \       
--       /:::/    /          \:::\    \      
--      /:::/    /            \:::\    \     
--     /:::/    /              \:::\    \    
--    /:::/    /               /::::\    \   
--   /:::/    /       _____   /::::::\    \  
--  /:::/    /       /\    \ /:::/\:::\    \ 
-- /:::/____/       /::\    /:::/  \:::\____\
-- \:::\    \       \:::\  /:::/    \::/    /
--  \:::\    \       \:::\/:::/    / \/____/ 
--   \:::\    \       \::::::/    /          
--    \:::\    \       \::::/    /           
--     \:::\    \       \::/    /            
--      \:::\    \       \/____/             
--       \:::\    \                          
--        \:::\____\                         
--         \::/    /                         
--          \/____/                          
--                                           

-- run :help <option> to find out what things are doing in detail, e.g. `:help warp`

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.syntax = "enable" -- syntax highlighting

vim.opt.mouse = "a" -- full mouse support

vim.opt.hidden = true -- buffers can become hidden - allow to leave a buffer without saving it to disk

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.hlsearch = false -- don't keep search result highlighted after pressing <CR>
vim.opt.incsearch = true -- search and show results while typing query
vim.opt.inccommand = "split" -- show effects of command within the screen an partially those that will happen off-screen in a preview window

vim.opt.ruler = true -- show a line and column number in statusbar
vim.opt.cmdheight = 2 -- number of lines used for the command line at the bottom

vim.opt.iskeyword:append("-")

vim.opt.splitbelow = true -- when calling :split, the bottom window will be in focus
vim.opt.splitright = true -- when calling :vsplit, the right window will be in focus

vim.opt.conceallevel = 0 -- concealments allow to replace patterns when rendered. e.g. `lambda x: x` with `λ x: x`. 0 disables this.
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in a file is converted to.
vim.opt.shiftwidth = 4 -- Number of spaces to use for (auto)indenting.
vim.opt.smarttab = true -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line
vim.opt.expandtab = true -- in insert mode conver a <Tab> press to spaces
vim.opt.autoindent = true -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
vim.opt.smartindent = true --  adjust indentation based on syntax TODO: review tpope/vim-sleuth.vim for an automated supposedly better indentation experience
vim.opt.textwidth = 100 -- max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width
vim.opt.wrap = false -- don't wrap lines visually
vim.opt.breakindent = true -- only matters if `wrap = true`; wrapped line will be equally indented if true

vim.opt.number = true -- show line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.background = "dark" -- use dark version of colorscheme
-- vim.opt.showtabline = 4 -- show tab line? 0: never, 1: if #tabs >= 2, 2: always -- disable, for plugin
vim.opt.termguicolors = true -- enable 24bit colors when running in terminal

vim.opt.signcolumn = 'yes' -- show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present

vim.opt.updatetime = 300 -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
vim.opt.timeoutlen = 1000 -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

vim.opt.clipboard = "unnamedplus" -- unify clipboards between vim and system
vim.opt.autochdir = true -- change working directory when opening new files / changing buffers -> MIGHT BRICK SOME PLUGINS

vim.opt.scrolloff = 8 -- minimum number of lines above/below cursor before scrolling starts

-- vim.opt.belloff = "all" -- turn of all bells

vim.opt.swapfile = false -- I like to live dangerously - and scream at myself when I edit the same file from different places
vim.opt.undofile = true -- persist the changes I make to my files in `:help undodir` so I can revert after restarts

vim.opt.ignorecase = true -- ignore character case when searching with /, ? or using commands n, N, and some more
vim.opt.smartcase = true -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase

vim.opt.formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

-- Set completeopt to have a better completion experienc
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt = "menuone,noinsert,noselect"

vim.opt.shortmess:append("c") -- avoid showing extra messages when using completion

vim.opt.showmode = false
