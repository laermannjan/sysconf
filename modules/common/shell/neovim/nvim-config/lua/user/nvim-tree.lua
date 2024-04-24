local M = {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", "NvimTree" } },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

M.config = function()
	require("nvim-tree").setup {}
end

return M
