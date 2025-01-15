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
        { '<leader>/', function() Snacks.picker.grep() end, desc = 'Search (workspace)' },
        { '<leader>?', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
        { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>d', function() Snacks.picker.diagnostics_buffer() end, desc = 'Diagnostics' },
        { '<leader>D', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics (open files)' },
        { '<leader>f', function() Snacks.picker.files({ hidden = true }) end, desc = 'Files' },
        { '<leader>h', function() Snacks.picker.help() end, desc = 'Help' },
        { '<leader>F', function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = 'Files (workspace)' },
        { '<leader>s', function() Snacks.picker.lsp_symbols() end, desc = 'Symbols' },
        { '<leader>S', function() Snacks.picker.lsp_symbols() end, desc = 'Symbols (workspace TODO)' },
        { '<leader>p', function() Snacks.picker.projects() end, desc = 'Projects' },
        { '<leader>P', function() Snacks.picker() end, desc = 'PickersProjectsProjects' },
        { '<leader>.', function() Snacks.picker.grep_word() end, desc = 'Grep (word or selection)', mode = { 'n', 'x' } },
        { "<leader>'", function() Snacks.picker.resume() end, desc = 'Resume' },

        { 'gr', function() Snacks.picker.lsp_references({ include_declaration = false }) end, desc = 'References' },
        { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Definition' },
        { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Declaration' },
        { 'gi', function() Snacks.picker.lsp_implementations() end, desc = 'Implementation' },
        { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Type definition' },

        { '<leader>u', '', desc = '+ui/toggles' },
        { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Show notifications' },
        { '<leader>g', function() Snacks.lazygit() end, desc = 'Lazygit' },
        { 'gF', function() Snacks.gitbrowse() end, desc = 'Open Git Remote URL' },
        { '<F2>', function() Snacks.rename.rename_file() end, desc = 'Rename file' },
        { [[<c-\>]], function() Snacks.terminal() end, desc = 'Toggle terminal', mode = { 'n', 't', 'i' } },
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
