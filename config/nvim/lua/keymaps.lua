vim.keymap.set('ca', 'W', 'w')
vim.keymap.set('ca', 'Wq', 'wq')
vim.keymap.set('ca', 'Wq!', 'wq!')
vim.keymap.set('ca', 'WQ!', 'wq!')
vim.keymap.set('ca', 'Q', 'q')
vim.keymap.set('ca', 'Q!', 'q!')
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
vim.keymap.set({ 'i', 'n', 's' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Clear search and <esc>' })

vim.keymap.set('n', '<S-h>', '^')
vim.keymap.set('n', '<S-l>', 'g_')

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Add undo break-points
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, { desc = 'Rename symbol' })
vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Code action' })
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, { desc = 'References' })
vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { desc = 'Definition' })
vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, { desc = 'Declaration' })
vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, { desc = 'Implementation' })
vim.keymap.set('n', 'gy', function() vim.lsp.buf.type_definition() end, { desc = 'Type definition' })
vim.keymap.set({ 'n', 'x' }, '=', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format' }) -- NOTE: use gq to sync format
