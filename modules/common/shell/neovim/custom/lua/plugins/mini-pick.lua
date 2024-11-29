return {
    'echasnovski/mini.pick',
    keys = {
        { '<leader>/', '<cmd>Pick grep_live<cr>', 'Grep' },
        { '<leader>fb', '<cmd>Pick buffers<cr>', 'Buffers' },
        { '<leader>ff', '<cmd>Pick files<cr>', 'Files' },
        { '<leader>fh', '<cmd>Pick help"<cr>', 'Helptags' },
        { '<leader>fw', '<cmd>Pick grep pattern="<cword>"<cr>', 'Grep word under cursor' },
    },
    opts = true,
    config = function(opts)
        require('mini.pick').setup(opts)
        vim.ui.select = MiniPick.ui_select
    end,
}
