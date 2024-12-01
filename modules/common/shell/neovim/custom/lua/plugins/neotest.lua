return {
    {
        'nvim-neotest/neotest',
        dependencies = { 'nvim-neotest/nvim-nio', 'nvim-lua/plenary.nvim' },
        opts = {
            adapters = {},
            status = { virtual_text = true },
            output = { open_on_run = true },
        },
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
        config = function(_, opts)
            local adapters = {}
            if opts.adapters then
                for name, config in ipairs(opts.adapters or {}) do
                    local adapter = require(name)
                    if type(config) == 'table' and not vim.tbl_isempty(config) then
                        local meta = getmetatable(adapter)
                        if adapter.setup then
                            adapter.setup(config)
                        elseif adapter.adapter then
                            adapter.adapter(config)
                            adapter = adapter.adapter
                        elseif meta and meta.__call then
                            adapter = adapter(config)
                        else
                            error('Adapter ' .. name .. ' does not support setup')
                        end
                    end

                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
            require('neotest').setup(opts)
        end,
    },
    {
        'mfussenegger/nvim-dap',
        optional = true,
        keys = {
            { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug Nearest' },
        },
    },
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/neotest-python',
        },
        opts = {
            adapters = {
                ['neotest-python'] = {
                    dap = { justMyCode = false },
                },
            },
        },
    },
}
