local M = {
	"neogitorg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		{ "sindrets/diffview.nvim", opts = {} },
	},
	event = "VeryLazy",
	keys = { { "<leader>gg", "<cmd>Neogit<CR>", "Neogit" } },
}

M.config = function()
	local icons = require "user.icons"
	require("neogit").setup {
		-- disable_commit_confirmation = true,
		disable_insert_on_commit = "auto",
		-- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
		-- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
		auto_refresh = true,
		graph_style = "unicode",
		use_magit_keybindings = false,
		-- customize displayed signs
		signs = {
			-- { CLOSED, OPENED }
			section = { icons.ui.ChevronRight, icons.ui.ChevronShortDown },
			item = { icons.ui.ChevronRight, icons.ui.ChevronShortDown },
			hunk = { "", "" },
		},
		telescope_sorter = function()
			return require("telescope").extensions.fzf.native_fzf_sorter()
		end,
		integrations = {
			telescope = true,
			diffview = true,
		},
	}
end

return M
