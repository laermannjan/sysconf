local M = {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
}

M.config = function()
	if S.colorscheme == "tokyonight" then
		require("tokyonight").setup {
			style = "night",
		}
		vim.cmd.colorscheme(S.colorscheme)
	end
end

return M
