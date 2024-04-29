{ ... }:
{
  programs.nixvim = {
    globals = {
      # # Disable useless providers
      # loaded_ruby_provider = 0; # Ruby
      # loaded_perl_provider = 0; # Perl
      # loaded_python_provider = 0; # Python 2
    };
    clipboard.register = "unnamedplus";
    opts = {
      hidden = true; # Keep closed buffer open in the background

      # line numbers
      relativenumber = true; # show relative line numbers
      number = true; # shows absolute line number on cursor line (when relative number is on)
      # tabs & indentation
      tabstop = 4; # Number of spaces that a <Tab> in a file is converted to.
      shiftwidth = 4; # Number of spaces to use for (auto)indenting.
      shiftround = true; # round indent to multiple of shiftwidth. > and < will move text to the next multiple of shiftwidth, instead of a fixed value
      smarttab = true; # insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
      expandtab = true; # in insert mode convert a <Tab> press to spaces
      autoindent = true; # indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
      smartindent = true; # adjust indentation based on syntax
      # showtabline = 4; # show tab line? 0: never, 1: if #tabs >= 2, 2: always # disable, for plugin
      textwidth = 128; # max width of text that is being inserted (e.g. pasted), line break on next whitespace after reaching this width (might be overridden in ftplugins)

      # line wrapping
      wrap = false; # disable line wrapping
      breakindent = true; # only matters if `wrap = true`; wrapped line will be equally indented if true

      cursorline = true; # highlight the current cursor line
      termguicolors = true; # enable 24bit colors when running in terminal
      signcolumn = "yes"; # show signcolumn at all times (like git gutter, code lense hints, etc.) even when nothing is present
      scrolloff = 8; # minimum number of lines above/below cursor before scrolling starts
      cmdheight = 1;
      showmode = false; # Dont show mode since we have a statusline

      clipboard = "unnamedplus"; # use system clipboard as default register

      # split windows
      splitright = true; # split vertical window to the right
      splitbelow = true; # split horizontal window to the bottom

      # search results & highlighting
      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true; # ignore character case when searching with /, ? or using commands n, N, and some more
      smartcase = true; # actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
      hlsearch = true; # keep search result highlighted after pressing <CR>
      incsearch = true; # search and show results while typing query
      inccommand = "split"; # show effects of command within the screen an partially those that will happen off-screen in a preview window

      # usability
      mouse = "a"; # full mouse support
      mousemodel = "extend"; # Mouse right-click extends the current selection
      # opt.laststatus = 3; # When to use a status line for the last window
      updatetime = 50; # If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
      timeoutlen = 500; # time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

      swapfile = false; # I like to live dangerously - and scream at myself when I edit the same file from different places
      undofile = true; # persist the changes I make to my files in `:help undodir` so I can revert after restarts
      undolevels = 10000;

      encoding = "utf-8";
      fileencoding = "utf-8";

      autowrite = true; # Auto save a buffer when jumping away from it
      conceallevel = 3; # conceal all items that have a conceal tag
      confirm = true; # Confirm to save changes before exiting modified buffer

      pumheight = 15; # number of items to show in a popup menu (autocompletion)
      pumblend = 18; # transparency value for that menu (0 opaque, 100 transparent)

      foldenable = false;
    };
  };
}
