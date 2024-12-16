return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        statuscolumn = { enabled = true },
        scope = { enabled = true },
        words = { enabled = true },
    },
    keys = {
        { '<leader>u', '', desc = '+ui/toggles' },
        { '<leader>un', '', desc = '+notifications' },
        { '<leader>uns', function() Snacks.notifier.show_history() end, desc = 'Show notifications' },
        { '<leader>unh', function() Snacks.notifier.hide() end, desc = 'Dismiss notifications' },
        { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete buffer' },
        { '<leader>g', '', desc = '+git' },
        { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
        { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Blame Line' },
        { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Browse URL' },
        { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Git log (file)' },
        { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Git log (cwd)' },
        { '<F2>', function() Snacks.rename.rename_file() end, desc = 'Rename file' },
        { '<c-/>', function() Snacks.terminal() end, desc = 'Toggle terminal' },
        { '<c-_>', function() Snacks.terminal() end, desc = 'which_key_ignore' },
        { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next reference', mode = { 'n', 't' } },
        { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev reference', mode = { 'n', 't' } },
    },
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...) Snacks.debug.inspect(...) end
                _G.bt = function() Snacks.debug.backtrace() end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
                Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
                Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
                Snacks.toggle.diagnostics():map('<leader>ud')
                Snacks.toggle.line_number():map('<leader>ul')
                Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
                Snacks.toggle.treesitter():map('<leader>uT')
                Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
                Snacks.toggle.inlay_hints():map('<leader>uh')
                Snacks.toggle.indent():map('<leader>ui')
                Snacks.toggle.dim():map('<leader>uD')
                Snacks.toggle.zen():map('<leader>uz')
                Snacks.toggle.zoom():map('<leader>uZ')
            end,
        })
    end,
}
