local M = {
	"yorik1984/newpaper.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		--
	},
}

M.config = function(_, opts)
	if vim.tbl_contains({ "newpaper" }, S.colorscheme) then
		require("newpaper").setup(opts)
		vim.cmd.colorscheme(S.colorscheme)
	end
end

return M
