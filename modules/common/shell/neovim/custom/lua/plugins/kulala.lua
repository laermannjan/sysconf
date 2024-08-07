return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	opts = {},
	keys = {
		{
			"[r",
			":lua require('kulala').jump_prev()<CR>",
			{ noremap = true, silent = true, desc = "jump to previous request" },
		},
		{
			"]r",
			":lua require('kulala').jump_next()<CR>",
			{ noremap = true, silent = true, desc = "jump to next request" },
		},
		{
			"<leader>r",
			":lua require('kulala').run()<CR>",
			{ noremap = true, silent = true, desc = "run request under cursor" },
		},
	},
}
