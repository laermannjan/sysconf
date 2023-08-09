local lazy_opts = {
    dev = {
        -- directory where you store your local plugin projects
        path = "~/code/lj/",
    },

    ui = {
        -- a number <1 is a percentage., >1 is a fixed size
        size = { width = 0.8, height = 0.8 },
        wrap = true, -- wrap the lines in the ui
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "double",
        colorscheme = { "tokyonight", "habamax" },
    },
}

require("lazy").setup({
    { import = "plugins.editor" },
    { import = "plugins.coding" },
    { import = "plugins.ui" },
}, lazy_opts)
