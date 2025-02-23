vim.keymap.set('n', '<cr>', function() require('kulala').run() end, { buffer = 0, silent = true, desc = 'Execute request under cursor (kulala)' })
vim.keymap.set('n', '<s-tab>', function() require('kulala').inspect() end, { buffer = 0, silent = true, desc = 'Inspect request under cursor (kulala)' })
vim.keymap.set('n', ']]', function() require('kulala').jump_next() end, { buffer = 0, silent = true, desc = 'Jump to next request (kulala)' })
vim.keymap.set('n', '[[', function() require('kulala').jump_prev() end, { buffer = 0, silent = true, desc = 'Jump to next request (kulala)' })
