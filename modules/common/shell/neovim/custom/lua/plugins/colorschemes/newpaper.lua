local M = {
	"yorik1984/newpaper.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		--
	},
}

M.config = function(_, opts)
	if vim.tbl_contains({ "newpaper" }, vim.g.colorscheme) then
		require("newpaper").setup(opts)
		vim.cmd.colorscheme(vim.g.colorscheme)
	end
end

return M
