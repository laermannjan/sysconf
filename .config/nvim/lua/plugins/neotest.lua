return {
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            adapters = {},
            status = { virtual_text = true },
            output = { open_on_run = true },
        },
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace('neotest')
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
                        return message
                    end,
                },
            }, neotest_ns)

            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == 'number' then
                        if type(config) == 'string' then config = require(config) end
                        adapters[#adapters + 1] = config
                    elseif config ~= false then
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
            end

            require('neotest').setup(opts)
        end,
        keys = {
            { '<leader>t', '', desc = '+test' },
            { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run file' },
            -- { '<leader>tF', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run all' },
            { '<leader>tF', function() require('neotest').run.run({ suite = true }) end, desc = 'Run all' },
            { '<leader>tt', function() require('neotest').run.run() end, desc = 'Run' },
            { '<leader>tr', function() require('neotest').run.run_last() end, desc = 'Re-run last' },
            { '<leader>tk', function() require('neotest').run.stop() end, desc = 'Kill' },
            { '<leader>ta', function() require('neotest').run.attach() end, desc = 'Attach' },
            { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle summary' },
            { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Show output' },
            { '<leader>tl', function() require('neotest').output_panel.toggle() end, desc = 'Toggle execution log' },
            { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Watch file (rerun tests)' },
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
