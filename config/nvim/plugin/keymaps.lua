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

vim.keymap.set('n', '<leader>c', ':norm gcc<CR>', { desc = 'Comment line' })
vim.keymap.set('v', '<leader>c', 'gc', { remap = true, desc = 'Comment selection' })
