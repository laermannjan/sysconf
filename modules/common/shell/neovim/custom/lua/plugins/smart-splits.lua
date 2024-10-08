local M = {
   "mrjones2014/smart-splits.nvim",
}

M.config = function()
   require("smart-splits").setup()
   -- moving between splits
   vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
   vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
   vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
   vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
   -- swapping buffers between windows
   vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left)
   vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down)
   vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up)
   vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right)
end

return M
