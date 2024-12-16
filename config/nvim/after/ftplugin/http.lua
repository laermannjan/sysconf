vim.keymap.set('n', '<cr>', "<cmd>lua require('kulala').run()<cr>", { buffer = 0, silent = true, desc = 'Execute request under cursor (kulala)' })
vim.keymap.set('n', '<s-tab>', "<cmd>lua require('kulala').inspect()<cr>", { buffer = 0, silent = true, desc = 'Inspect request under cursor (kulala)' })
