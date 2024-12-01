return {
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            'nvim-neotest/neotest-python',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            -- adapters = {
            --     require('neotest-python')({
            --         -- dap = { justMyCode = false },
            --     }),
            -- },
            -- status = { virtual_text = true },
            -- output = { open_on_run = true },
        },
        config = function(_, opts)
            require('neotest').setup({
                adapters = {
                    require('neotest-python')({}),
                },
            })
        end,
        keys = {
            { '<leader>t', '', desc = '+test' },
            { '<leader>ta', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'All (file)' },
            { '<leader>tA', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'All (project)' },
            { '<leader>tt', function() require('neotest').run.run() end, desc = 'Nearest' },
            { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Last' },
            { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle summary' },
            { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Output' },
            { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Output panel' },
            { '<leader>tx', function() require('neotest').run.stop() end, desc = 'Stop' },
            { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Toggle Watch' },
        },
    },
    {
        'mfussenegger/nvim-dap',
        optional = true,
        keys = {
            { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug Nearest' },
        },
    },
}
