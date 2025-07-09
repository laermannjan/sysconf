return {
    'cbochs/grapple.nvim',
    opts = {
        scope = 'git', -- also try out "git_branch"
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
        { '<localleader>m', '<cmd>Grapple tag<cr>', desc = 'Mark file' },
        { '<leader>m', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle mark list' },
        { '<localleader-1>', '<cmd>Grapple select index=1<cr>', desc = 'Grapple to 1. file' },
        { '<localleader-2>', '<cmd>Grapple select index=2<cr>', desc = 'Grapple to 2. file' },
        { '<localleader-3>', '<cmd>Grapple select index=3<cr>', desc = 'Grapple to 3. file' },
        { '<localleader-4>', '<cmd>Grapple select index=4<cr>', desc = 'Grapple to 4. file' },
        { '<localleader-5>', '<cmd>Grapple select index=5<cr>', desc = 'Grapple to 5. file' },
    },
}
