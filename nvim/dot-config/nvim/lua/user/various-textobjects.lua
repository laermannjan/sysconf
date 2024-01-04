local M = {
	"chrisgrieser/nvim-various-textobjs",
	lazy = false,
}

function M.config()
	require("various-textobjs").setup { useDefaultKeymaps = false }

	vim.keymap.set({ "o", "x" }, "aw", "<cmd>lua require('various-textobjs').subword('outer')<CR>")
	vim.keymap.set({ "o", "x" }, "iw", "<cmd>lua require('various-textobjs').subword('inner')<CR>")

	vim.keymap.set({ "o", "x" }, "!", "<cmd>lua require('various-textobjs').diagnostic()<CR>")
	vim.keymap.set({ "o", "x" }, "/", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")
	vim.keymap.set({ "o", "x" }, "iq", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>")
	vim.keymap.set({ "o", "x" }, "aq", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>")
	vim.keymap.set({ "o", "x" }, "ib", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>")
	vim.keymap.set({ "o", "x" }, "ab", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>")
end

return M
