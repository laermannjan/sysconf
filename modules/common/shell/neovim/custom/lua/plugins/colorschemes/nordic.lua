local M = {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		bold_keywords = true,
	},
}

M.config = function(_, opts)
	if S.colorscheme == "nordic" then
		require("nordic").load(opts)
	end
end

return M
