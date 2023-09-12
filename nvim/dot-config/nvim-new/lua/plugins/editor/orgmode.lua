return {
    {
        "nvim-orgmode/orgmode",
        config = function()
            require('orgmode').setup_ts_grammar()
            require('orgmode').setup({
                org_agenda_files = { '~/Documents/Notes/*', '~/code/lj/*', '~/code/alcemy/*' },
                org_default_notes_file = '~/Documents/Notes/refile.org',
            })
        end
    },
    {
        "akinsho/org-bullets.nvim",
        opts = {}
    }
}
