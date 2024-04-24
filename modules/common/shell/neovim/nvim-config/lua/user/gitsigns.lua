local icons = require "user.icons"
local M = {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	opts = {
		signs = {
			add = { text = icons.ui.BoldLineMiddle },
			change = { text = icons.ui.BoldLineMiddle },
			delete = { text = icons.ui.TriangleShortArrowRight },
			topdelete = { text = icons.ui.TriangleShortArrowRight },
			changedelete = { text = icons.ui.BoldLineMiddle },
			untracked = { text = icons.ui.BoldLineMiddle },
		},
		-- attach_to_untracked = true,
	},
	keys = {
		{ "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "blame line" },
		{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "git diff against base" },
		{ "<leader>ugb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "toggle current blame line" },
		{ "<leader>ugd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "toggle current blame line" },
	},
}

return M
