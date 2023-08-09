local keymap = vim.keymap.set

keymap("n", "<C-d>", "<C-d>zz") -- center view when scrolling half page down
keymap("n", "<C-u>", "<C-u>zz") -- center view when scrolling half page up
keymap("n", "n", "nzzzv") -- center next search result
keymap("n", "N", "Nzzzv") -- center prev search result

keymap("n", "Q", "<nop>")

-- move selected text around with J/K
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- keep the cursor at the same position when joining the next line with J
keymap("n", "J", "mzJ`z")

-- Paste
keymap("n", "]p", "o<Esc>p", { desc = "Paste below" })
keymap("n", "]P", "O<Esc>p", { desc = "Paste above" })

-- Insert blank line
keymap("n", "]<Space>", "o<Esc>")
keymap("n", "[<Space>", "O<Esc>")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "<C-P>", "p") -- original p, copies what's been overwritten
keymap("v", "p", '"_dp') -- paste over without copy

-- yank into system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Yank current line to clipboard" })

keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear search highlight" })

keymap({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- lazy
keymap("n", "<leader>ps", "<cmd>Lazy<cr>", { desc = "Plugins Status" })
keymap("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Plugins Update" })
keymap("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Open Mason Installer" })
keymap("n", "<leader>pM", "<cmd>MasonUpdate<cr>", { desc = "Update Mason packages" })

keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
keymap("n", "<leader>W", "<cmd>w!<cr>", { desc = "Force Save" })
keymap("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })

-- new file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- stylua: ignore
keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })
