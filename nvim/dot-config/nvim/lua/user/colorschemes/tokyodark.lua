local M = {
	"tiagovla/tokyodark.nvim",
	opts = {
		-- custom options here
	},
	config = function(_, opts)
		if S.colorscheme == "tokyodark" then
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd [[colorscheme tokyodark]]
		end
	end,
}

return M
