local M = {
	"tiagovla/tokyodark.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		gamma = 1.2, -- adjust the brightness of the theme
	},
	config = function(_, opts)
		if vim.g.colorscheme == "tokyodark" then
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd.colorscheme(vim.g.colorscheme)
		end
	end,
}

return M
