local nnoremap = function(lhs, rhs, silent)
  vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true, silent = silent })
end

local inoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true })
end

local vnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap("v", lhs, rhs, { noremap = true })
end

-- Escape redraws the screen and removes any search highlighting.
nnoremap("<esc>", ":noh<return><esc>")

-- Map Ctrl-Backspace/w to delete the previous word in insert mode.
inoremap("<C-w>", "<C-\\><C-o>dB")
inoremap("<C-BS>", "<C-\\><C-o>db")

-- Coment
-- nnoremap("<space>;", '<cmd>lua require("functions/comment")()<CR>')
-- vnoremap("<space>;", '<cmd>lua require("functions/comment")()<CR>')

-- LSP
nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", true)
nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", true)
nnoremap("gr", "<cmd>LspTrouble lsp_references<CR>", true)
nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", true)
nnoremap("<C-space>", "<cmd>lua vim.lsp.buf.hover()<CR>", true)
vnoremap("<C-space>", "<cmd>RustHoverRange<CR>")

nnoremap("ge", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", true)
nnoremap("gE", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", true)
vnoremap("<Leader>a", "<cmd>lua vim.lsp.buf.range_code_action()<CR>")

nnoremap("<Leader>ld", "<cmd>LspTrouble lsp_definitions<CR>", true)
nnoremap(
  "<Leader>le",
  "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
  true
)
nnoremap("<Leader>lE", "<cmd>LspTroubleWorkspaceToggle<CR>", true)

inoremap(
  "<C-f>",
  '<Esc> :lua require("functions/telescope").search_in_buffer()<CR>'
)
