return {
    'cbochs/grapple.nvim',
    opts = {
        scope = 'git', -- also try out "git_branch"
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
        { '<leader>a', '<cmd>Grapple tag<cr>', desc = 'Mark file' },
        { '<leader>m', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle mark list' },
        { '<c-h>', '<cmd>Grapple select index=1<cr>', desc = 'Grapple to 1. file' },
        { '<c-j>', '<cmd>Grapple select index=2<cr>', desc = 'Grapple to 2. file' },
        { '<c-k>', '<cmd>Grapple select index=3<cr>', desc = 'Grapple to 3. file' },
        { '<c-l>', '<cmd>Grapple select index=4<cr>', desc = 'Grapple to 4. file' },
        { '<c-;>', '<cmd>Grapple select index=5<cr>', desc = 'Grapple to 5. file' },
    },
}
