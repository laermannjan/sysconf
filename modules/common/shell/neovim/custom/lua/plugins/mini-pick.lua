return {
    'echasnovski/mini.pick',
    opts = true,
    config = function(opts)
        require('mini.pick').setup(opts)
        vim.ui.select = MiniPick.ui_select
    end,
}
