local M = {
	"tiagovla/tokyodark.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		gamma = 1.2, -- adjust the brightness of the theme
	},
	config = function(_, opts)
		if S.colorscheme == "tokyodark" then
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd.colorscheme(S.colorscheme)
		end
	end,
}

return M
