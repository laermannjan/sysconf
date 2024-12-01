return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        statuscolumn = { enabled = true },
    },
    keys = {
        { '<leader>n', '', desc = '+notifications' },
        { '<leader>ns', function() Snacks.notifier.show_history() end, desc = 'Show notifications' },
        { '<leader>nh', function() Snacks.notifier.hide() end, desc = 'Dismiss notifications' },
        { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete buffer' },
        { '<leader>g', '', desc = '+git' },
        { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
        { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Blame Line' },
        { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Browse URL' },
        { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Git log (file)' },
        { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Git log (cwd)' },
        { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename file' },
        { '<c-/>', function() Snacks.terminal() end, desc = 'Toggle terminal' },
        { '<c-_>', function() Snacks.terminal() end, desc = 'which_key_ignore' },
        { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next reference', mode = { 'n', 't' } },
        { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev reference', mode = { 'n', 't' } },
    },
}
