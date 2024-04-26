local M = {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		--
	},
}

M.config = function(_, opts)
	if vim.tbl_contains({ "nightfox", "duskfox", "terafox" }, S.colorscheme) then
		require("nightfox").setup(opts)
		vim.cmd.colorscheme(S.colorscheme)
	end
end

return M
