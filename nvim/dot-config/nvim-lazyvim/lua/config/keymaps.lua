-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set

keymap("n", "<leader>fs", ":w<CR>", { desc = "Save file", silent = true })
keymap("v", "p", '"_dP', { desc = "Paste without yank", silent = true })
