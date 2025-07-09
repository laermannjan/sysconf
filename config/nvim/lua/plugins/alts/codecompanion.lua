return {
    { 'CopilotC-Nvim/CopilotChat.nvim', enabled = false },
    {
        'olimorris/codecompanion.nvim',
        cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
        lazy = false,
        keys = {
            {
                '<C-a>',
                '<cmd>CodeCompanionActions<CR>',
                desc = 'Open the action palette',
                mode = { 'n', 'v' },
            },
            {
                '<Leader>a',
                '<cmd>CodeCompanionChat Toggle<CR>',
                desc = 'Toggle a chat buffer',
                mode = { 'n', 'v' },
            },
            {
                '<LocalLeader>a',
                '<cmd>CodeCompanionChat Add<CR>',
                desc = 'Add code to a chat buffer',
                mode = { 'v' },
            },
        },
        init = function() vim.cmd([[cab cc CodeCompanion]]) end,
        opts = {
            strategies = {
                chat = {
                    adapter = {
                        name = 'copilot',
                        model = 'claude-sonnet-4',
                    },
                    keymaps = {
                        send = { modes = { i = { '<C-CR', '<C-s>' } } },
                        completion = { modes = { i = '<C-x>' } },
                    },
                },
                inline = {
                    adapter = {
                        name = 'copilot',
                        model = 'gpt-4.1',
                    },
                },
            },
        },
        deps = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
    },
}
