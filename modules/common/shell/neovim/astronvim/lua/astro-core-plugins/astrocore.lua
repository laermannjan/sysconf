-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- -- Configure core features of AstroNvim
    -- features = {
    --   large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
    --   autopairs = true, -- enable autopairs at start
    --   cmp = true, -- enable completion at start
    --   diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
    --   highlighturl = true, -- highlight URLs at start
    --   notifications = true, -- enable notifications at start
    -- },
    -- -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    -- diagnostics = {
    --   virtual_text = true,
    --   underline = true,
    -- },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto

        -- tabs & indentation
        tabstop = 4, -- Number of spaces that a <Tab> in a file is converted to.
        shiftwidth = 4, -- Number of spaces to use for (auto)indenting.
        shiftround = true, -- round indent to multiple of shiftwidth. > and < will move text to the next multiple of shiftwidth, instead of a fixed value
        smarttab = true, -- insert `shiftwidth` spaces, when hitting <Tab> infront of a line, also delete them in one go when hitting backspace
        expandtab = true, -- in insert mode convert a <Tab> press to spaces
        autoindent = true, -- indent next line similarly to current line when pressing <CR> in insert or o/O in normal mode
        smartindent = true, --  adjust indentation based on syntax

        -- line wrapping
        wrap = false, -- disable line wrapping
        breakindent = true, -- only matters if `wrap = true`; wrapped line will be equally indented if true

        clipboard = "unnamedplus", -- use system clipboard as default register

        -- split windows
        splitright = true, -- split vertical window to the right
        splitbelow = true, -- split horizontal window to the bottom

        -- search results & highlighting
        -- Case-insensitive searching UNLESS \C or capital in search
        ignorecase = true, -- ignore character case when searching with /, ? or using commands n, N, and some more
        smartcase = true, -- actually DO care about case when I type UPPERCASE specifically, but ignore where i type lowercase
        hlsearch = true, -- keep search result highlighted after pressing <CR>
        incsearch = true, -- search and show results while typing query

        -- usability
        mouse = "a", -- full mouse support
        -- opt.laststatus = 3
        updatetime = 50, -- If this many milliseconds nothing is typed the swap file will be written to disk; Also used for the |CursorHold| autocommand event
        timeoutlen = 500, -- time in ms to wait before mapped sequence completes. e.g. if pressing <leader> before continuing to type normaly

        swapfile = false, -- I like to live dangerously - and scream at myself when I edit the same file from different places
        undofile = true, -- persist the changes I make to my files in `:help undodir` so I can revert after restarts
        undolevels = 10000,

        encoding = "utf-8",
        fileencoding = "utf-8",

        autowrite = true, -- Auto save a buffer when jumping away from it
        conceallevel = 3, -- conceal all items that have a conceal tag
        confirm = true, -- Confirm to save changes before exiting modified buffer

        -- pumheight = 15, -- number of items to show in a popup menu (autocompletion)
        -- pumblend = 18, -- transparency value for that menu (0 opaque, 100 transparent)
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        n = { "nzzzv" },
        N = { "Nzzzv" },
        ["*"] = { "*zzzv" },
        ["#"] = { "#zzzv" },
        ["g*"] = { "g*zzzv" },
        ["g#"] = { "g#zzzv" },
        H = { "^" },
        L = { "g_" },
        ["<esc>"] = { ":noh<cr><esc>" },
      },
      v = {
        ["<"] = { "<gv" },
        [">"] = { ">gv" },
        p = { '"_dP' },
      },
      i = {
        ["."] = { "<c-g>u." },
        [","] = { "<c-g>u," },
        [";"] = { "<c-g>u;" },
      },
      --     -- first key is the mode
      --     n = {
      --       -- second key is the lefthand side of the map
      --
      --       -- navigate buffer tabs with `H` and `L`
      --       -- L = {
      --       --   function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      --       --   desc = "Next buffer",
      --       -- },
      --       -- H = {
      --       --   function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      --       --   desc = "Previous buffer",
      --       -- },
      --
      --       -- mappings seen under group name "Buffer"
      --       ["<Leader>bD"] = {
      --         function()
      --           require("astroui.status.heirline").buffer_picker(
      --             function(bufnr) require("astrocore.buffer").close(bufnr) end
      --           )
      --         end,
      --         desc = "Pick to close",
      --       },
      --       -- tables with just a `desc` key will be registered with which-key if it's installed
      --       -- this is useful for naming menus
      --       ["<Leader>b"] = { desc = "Buffers" },
      --       -- quick save
      --       -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      --     },
      --     t = {
      --       -- setting a mapping to false will disable it
      --       -- ["<esc>"] = false,
      --     },
    },
  },
}
