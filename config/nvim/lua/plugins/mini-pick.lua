return {
    'echasnovski/mini.pick',
    dependencies = {
        'mini.icons',
        'mini.extra',
    },
    cmd = { 'Pick' },
    keys = {
        { '<leader>/', '<cmd>Pick grep_live<cr>', desc = 'Grep' },
        { '<leader>fb', '<cmd>Pick buffers<cr>', desc = 'Buffers' },
        { '<leader>fs', '<cmd>Pick spellsuggest<cr>', desc = 'Spell suggestion (word under cursor)' },
        { '<leader>fd', '<cmd>Pick diagnostics scope="current"<cr>', desc = 'Diagnostics' },
        { '<leader>fD', '<cmd>Pick diagnostics scope="all"<cr>', desc = 'Diagnostics (project)' },
        { '<leader>ff', '<cmd>Pick files<cr>', desc = 'Files' },
        { '<leader>fe', '<cmd>Pick explorer<cr>', desc = 'Explorer' },
        { '<leader>fk', '<cmd>Pick keymaps<cr>', desc = 'Keymaps' },
        { '<leader>fh', '<cmd>Pick help<cr>', desc = 'Helptags' },
        { '<leader>fo', '<cmd>Pick options<cr>', desc = 'Options' },
        { '<leader>fr', '<cmd>Pick oldfiles<cr>', desc = 'Recent files' },
        { '<leader>fw', '<cmd>Pick grep pattern="<cword>"<cr>', desc = 'Grep (word under cursor)' },
        -- { 'gr', '<cmd>Pick lsp scope="references"<cr>', desc = 'References' },
    },
    opts = true,
    config = function(_, opts)
        require('mini.pick').setup(opts)
        vim.ui.select = MiniPick.ui_select
    end,
}
