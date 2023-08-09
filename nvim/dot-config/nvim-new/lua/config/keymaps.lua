local keymap = vim.keymap.set

-- keymap("n", "<C-d>", "<C-d>zz") -- center view when scrolling half page down
-- keymap("n", "<C-u>", "<C-u>zz") -- center view when scrolling half page up
keymap("n", "n", "nzzzv") -- center next search result
keymap("n", "N", "Nzzzv") -- center prev search result

-- indent and be able to indent again
keymap("v", "<", "<gv")

keymap("v", ">", ">gv")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

keymap("v", "p", '"_dp') -- paste over without copy

keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear search highlight" })

keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
keymap("n", "<leader>qw", "<cmd>qw<cr>", { desc = "Save & Quit all" })
keymap("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })
