vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<ESC>", "<cmd>noh<cr><ESC>", { silent = true })
vim.keymap.set("n", "n", "nzzzv") -- center next search result
vim.keymap.set("n", "N", "Nzzzv") -- center prev search result
vim.keymap.set("n", "*", "*zzzv") -- center next search result
vim.keymap.set("n", "#", "#zzzv") -- center prev search result
vim.keymap.set("n", "g*", "g*zzzv") -- center next search result
vim.keymap.set("n", "g#", "g#zzzv") -- center prev search result

vim.keymap.set({ "n", "o", "x" }, "<s-h>", "^") -- goto start of line
vim.keymap.set({ "n", "o", "x" }, "<s-l>", "g_") -- goto end of line

-- indent and be able to indent again
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Add undo break-points
vim.keymap.set("i", ",", "<c-g>u,")
vim.keymap.set("i", ".", "<c-g>u.")
vim.keymap.set("i", ";", "<c-g>u;")

vim.keymap.set("v", "p", '"_dP') -- paste over without copy

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "goto previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "goto next diagnostic message" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

vim.keymap.set({ "n", "x" }, "j", "gj")
vim.keymap.set({ "n", "x" }, "k", "gk")
vim.keymap.set("n", "<leader>uw", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", { desc = "toggle line wrap" })

vim.keymap.set("t", "<C-;>", "<C-\\><C-n>")

-- Better window navigation
vim.keymap.set("n", "<m-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<m-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<m-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<m-l>", "<C-w>l", { noremap = true, silent = true })
