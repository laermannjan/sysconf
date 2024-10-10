-- Helper function
local keymap = function(mode, keys, cmd, opts)
  opts = opts or {}
  if opts.silent == nil then opts.silent = true end
  vim.keymap.set(mode, keys, cmd, opts)
end

-- Remove search highlights on <esc>
-- keymap({"n", "v"}, "<esc>", "<cmd>noh<cr><esc>", { silent = true })

-- Stop highlighting of search results. NOTE: this can be done with default
-- `<C-l>` but this solution deliberately uses `:` instead of `<Cmd>` to go
-- into Command mode and back which updates 'mini.map'.
keymap('n', [[\h]], ':let v:hlsearch = 1 - v:hlsearch<CR>', { desc = 'Toggle hlsearch' })

-- Better command history navigation
keymap('c', '<C-p>', '<Up>', { silent = false })
keymap('c', '<C-n>', '<Down>', { silent = false })


keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({severity = "ERROR"})<cr>')
keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next({severity = "ERROR"})<cr>')
