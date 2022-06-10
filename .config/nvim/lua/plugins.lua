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

-- Install packer (if not already installed)
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- use("akinsho/bufferline.nvim") -- a buffer line at the top (like displaying the tabs in a browser)
    use({ 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }) -- another bufferline
    use("antoinemadec/FixCursorHold.nvim") -- decouple updatetime from CursorHold and CursorHoldI, which improves speed / resource utilization for plugins that trigger on these
    use("max397574/better-escape.nvim") -- insert-mode escape shortcuts that don't introduce lag
    use("lambdalisue/suda.vim") -- reopen and write files with sudo
    -- =====================
    -- UI STUFF
    -- =====================

    use({ 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }) -- status line
    use("folke/trouble.nvim") -- pretty lists for hints, warnings, errors, diagnostics, etc.
    use("norcalli/nvim-colorizer.lua") -- sets the backround of a color code to that color, e.g. background of #FFFFFF should be white
    use("lukas-reineke/indent-blankline.nvim") -- shows vertical indentation guides to better visually parse deeply nested code
    use("ludovicchabant/vim-gutentags") -- automatic tag management - tags are an index of "names" found in source files to be used by code comprehension tools - TODO: not totally sure what they help me with
    use("kosayoda/nvim-lightbulb") -- show a lightbulb in the gutter when code action available

    use("RRethy/nvim-base16") -- base16 colorschemes lua port with treesitter support

    use("numToStr/Navigator.nvim") -- vim pane/split navigations (no tmux)
    -- use({ "glepnir/dashboard-nvim", requires = { "nvim-telescope/telescope.nvim" } }) -- dashboard
    use("karb94/neoscroll.nvim") -- smooth scrolling!, with <C-d>, <C-u>, <C-b>, <C-f>, <C-y>, <C-e>, zt, zz, zb, instead of jumping, you actually get moving text
    use("edluffy/specs.nvim") -- show traces when your cursor moves large distances
    use("glepnir/lspsaga.nvim") -- beautiful UI elements for LSP features

    -- =====================
    -- TELESCOPE --
    -- =====================
    use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" } })
    use({ "romgrk/fzy-lua-native", requires = { "nvim-telescope/telescope.nvim" } })
    use({ "nvim-telescope/telescope-fzy-native.nvim", requires = { "nvim-telescope/telescope.nvim" } })
    use({ "nvim-telescope/telescope-project.nvim", requires = { "nvim-telescope/telescope-file-browser.nvim" } })
    use("nvim-telescope/telescope-file-browser.nvim")
    use({ 'nvim-telescope/telescope-z.nvim', requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim', 'nvim-telescope/telescope.nvim' } }) -- zoxide integration

    -- =====================
    -- CODING STUFF
    -- =====================

    -- LSP - LANGUAGE SERVER PROTOCOL
    use({
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        wants = {
            "nvim-lsp-ts-utils",
            "null-ls.nvim",
            "lua-dev.nvim",
            -- "cmp-nvim-lsp",
            "nvim-lsp-installer",
        },
        config = function()
            require("config.lsp")
        end,
        requires = {
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            "jose-elias-alvarez/null-ls.nvim",
            "folke/lua-dev.nvim",
            "williamboman/nvim-lsp-installer", -- install LSP servers from inside nvim (instead of via system package manager)
        },
    })


    use({ -- code gps - statusline info where in the code structure your cursor is. e.g. mymodule > myclass > mymethod
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
        wants = "nvim-treesitter",
        module = "nvim-gps",
        config = function()
            require("nvim-gps").setup({ separator = " " })
        end,
    })

    use("vim-test/vim-test") -- testing suite

    -- AUTO COMPLETION (cmp is the `compe` of nvim)
    use("hrsh7th/nvim-cmp") -- main completion framework
    use("hrsh7th/cmp-nvim-lsp") -- completions for neovim's builtin language server protocol implementation
    use("hrsh7th/cmp-buffer") -- completions wihtin a buffer
    use("hrsh7th/cmp-emoji") -- emoji completions
    use("hrsh7th/cmp-path") -- completions for file system paths
    use("hrsh7th/cmp-cmdline") -- vim command line completions

    -- SNIPPETS
    use("L3MON4D3/LuaSnip") -- snippet plugin
    use("saadparwaiz1/cmp_luasnip") -- snippet completion sources

    -- TREE-SITTER - the syntax parser generator tool for any language
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("windwp/nvim-ts-autotag") -- rename/refactor html tags in html, typescript, php, svelte with `ciw<...>`
    -- use("JoosepAlviste/nvim-ts-context-commentstring") -- change commenting style based on context. useful for embedded languages (e.g. in `yew` where html code resides inside rust code). Only needed in rare cases when using numToStr.Comment instead of vim-commentary
    -- use("nvim-treesitter/nvim-treesitter-textobjects") -- syntax away text-objects and actions - allows you to define custom mappings similar to ip (inner paragraph) TODO investigate if useful

    -- Neovim / lua dev
    use("folke/lua-dev.nvim") -- properly setups require paths for lua plugins for neovim, DISABLE WHEN WRITING OTHER LUA PROJECT. TODO: check if needed (try disable and modity init.lua)
    use({ "ckipp01/stylua-nvim", run = "cargo install stylua" }) -- lua formatter + auto install

    -- Navigation
    use({ "kevinhwang91/rnvimr", run = ":make sync" }) -- uses ranger (binary dependeny) over netrw. TODO: Test if suitable

    -- text manipulation
    use("numToStr/Comment.nvim") -- neovim commenting plugin. similar to tpope/vim-commentary, but integrates with tree-sitter adapt the commenstring automatically. In edgecases needs nvim-ts-context-commentstring, see repo.
    use("windwp/nvim-autopairs") -- add/match pairs of brackets, paranthesis, etc. - I like because it doesn't add unnecessary closings if they are already present. e.g.: | = cursor,  current = `(  |))`, input = `(`, result = `(  (|))`
    use("folke/twilight.nvim") -- dim / grey out inactive portions your code while editing  TODO: check if you like it
    use("folke/zen-mode.nvim") -- distraction free coding TODO: configure !!!

    -- helpers & info
    use("ray-x/lsp_signature.nvim") -- Show a popup with signature info
    use("folke/todo-comments.nvim") -- make todo comments like TODO, HACK, BUG, PERF, FIX, WARNING, NOTE more prominent and observable in their own list via :TodoQuickFix, :TodoLocList, :TodoTelesecope
    use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }) -- show indicators in the git gutter
    use("tpope/vim-fugitive") -- basically a nice wrapper around `:!git` that bring many quality of life improvements. run any command from the command line `git <cmd>` with `:G <cmd>`. See :G mergetool, :G difftool, :G[v]diffsplit, and press `g?` after entering `:G`
    use({ 'TimUntersberger/neogit', requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' } }) -- emacs magit vim fork (WIP, but worth a try), checkout https://magit.vc/ - the best git interface!

    -- =====================
    -- DEBUGGING
    -- =====================
    use("mfussenegger/nvim-dap") -- the [D]ebugging [A]datapter [P]rotocol plugin. This is a framework that needs adapters installed per language.
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }) -- a DAP ui with some opinionated defaults - not necessary, disable at will.
    -- TODO: checkout out DAP adapter implemenations like ttps://github.com/mfussenegger/nvim-dap-python/
    use("simrat39/rust-tools.nvim") -- a wrapper around rust_analyzer with addition debuggion functionality

    use("folke/which-key.nvim") -- show popup that displays possible keybinds of the command you started typing. TODO: configure!!!

    -- =====================
    -- RANDOM & FUN STUFF
    -- =====================
    use("andweeb/presence.nvim") -- show a "Rich Presence" in discord when in neovim
    use("tjdevries/train.nvim") -- train vim motions - :TrainUpDown, :TrainWord, :TrainTextObj

end)
