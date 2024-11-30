return {
    'echasnovski/mini.pick',
    dependencies = {
        'mini.icons',
        'mini.extra',
    },
    keys = {
        { '<leader>/', '<cmd>Pick grep_live<cr>', desc = 'Grep' },
        { '<leader>fb', '<cmd>Pick buffers<cr>', desc = 'Buffers' },
        { '<leader>ff', '<cmd>Pick files<cr>', desc = 'Files' },
        { '<leader>fh', '<cmd>Pick help<cr>', desc = 'Helptags' },
        { '<leader>fw', '<cmd>Pick grep pattern="<cword>"<cr>', desc = 'Grep word under cursor' },
    },
    opts = true,
    config = function(_, opts)
        require('mini.pick').setup(opts)
        vim.ui.select = MiniPick.ui_select
    end,
}
