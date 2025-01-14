local actions = require('telescope.actions')
return {

    {
        'echasnovski/mini.pick',
        enabled = false,
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        lazy = false,
        cmd = { 'Telescope' },
        keys = {
            { '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Search workspace' },
            { '<leader>?', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
            { '<leader>h', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
            { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
            { '<leader>d', '<cmd>Telescope diagnostic scope="current"<cr>', desc = 'Diagnostics' },
            { '<leader>D', '<cmd>Telescope diagnostic scope="all"<cr>', desc = 'Diagnostics (project)' },
            { '<leader>f', '<cmd>Telescope fd hidden=true<cr>', desc = 'Files' },
            { '<leader>F', '<cmd>Telescope fd hidden=true no_ignore=true<cr>', desc = 'Files (incl. ignored)' },
            { '<leader>s', '<cmd>Telescope document_symbol<cr>', desc = 'Symbols' },
            { '<leader>S', '<cmd>Telescope workspace_symbol<cr>', desc = 'Workspace symbols' },
            { '<leader>w', '<cmd>Telescope grep_string<cr>', desc = 'Grep (word under cursor)' },
            { "<leader>'", '<cmd>Telescope resume<cr>', desc = 'Resume last search' },
            { 'mS', '<cmd>Pick spellsuggest<cr>', desc = 'Spell suggestion (word under cursor)' },
        },
        opts = {
            defaults = {
                mappings = { i = { ['<esc>'] = actions.close } },
                path_display = { 'truncate' },
                layout_config = { prompt_position = 'top' },
                sorting_strategy = 'ascending',
            },
            pickers = {
                find_files = {
                    find_command = { 'fd', '--type', 'f', '--full-path', '--exclude', '.git/' },
                },
                fd = {
                    find_command = { 'fd', '--type', 'f', '--full-path', '--exclude', '.git/' },
                },
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('ui-select')
        end,
    },
}
