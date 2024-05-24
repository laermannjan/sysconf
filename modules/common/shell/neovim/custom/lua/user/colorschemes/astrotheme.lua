local M = {
	"AstroNvim/astrotheme",
	lazy = false,
	priority = 1000,
	opts = {
		--
	},
}

M.config = function(_, opts)
	if vim.tbl_contains({ "astrodark", "astromars", "astrolight" }, S.colorscheme) then
		require("astrotheme").setup(opts)
		vim.cmd.colorscheme(S.colorscheme)
	end
end

return M
