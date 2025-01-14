return {
    'echasnovski/mini.pick',
    version = false,
    dependencies = {
        'mini.icons',
        'mini.extra',
    },
    cmd = { 'Pick' },
    keys = {
        { '<leader>/', '<cmd>Pick grep_live<cr>', desc = 'Search workspace' },
        { '<leader>?', '<cmd>Pick keymaps<cr>', desc = 'Keymaps' },
        { '<leader>b', '<cmd>Pick buffers<cr>', desc = 'Buffers' },
        { '<leader>d', '<cmd>Pick diagnostic scope="current"<cr>', desc = 'Diagnostics' },
        { '<leader>D', '<cmd>Pick diagnostic scope="all"<cr>', desc = 'Diagnostics (project)' },
        { '<leader>f', '<cmd>Pick cli command={"fd","--hidden"}<cr>', desc = 'Files' },
        { '<leader>F', '<cmd>Pick cli command={"fd","--hidden","--no-ignore"}<cr>', desc = 'Files (incl. ignored)' },
        { '<leader>s', '<cmd>Pick lsp scope="document_symbol"<cr>', desc = 'Symbols' },
        { '<leader>S', '<cmd>Pick lsp scope="workspace_symbol"<cr>', desc = 'Workspace symbols' },
        { '<leader>w', '<cmd>Pick grep pattern="<cword>"<cr>', desc = 'Grep (word under cursor)' },
        { "<leader>'", '<cmd>Pick resume<cr>', desc = 'Resume last search' },
        { 'mS', '<cmd>Pick spellsuggest<cr>', desc = 'Spell suggestion (word under cursor)' },
    },
    opts = true,
    config = function(_, opts)
        require('mini.pick').setup(opts)
        vim.ui.select = MiniPick.ui_select
    end,
}
