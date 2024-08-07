local prefix = "<Leader><Leader>"

local M = {
	"cbochs/grapple.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	cmd = { "Grapple" },
	keys = {

		{ prefix, desc = "Grapple", icon = require("config.icons").misc.Grapple },
		{ prefix .. "a", "<Cmd>Grapple tag<CR>", desc = "Add file" },
		{ prefix .. "d", "<Cmd>Grapple untag<CR>", desc = "Remove file" },
		{ prefix .. "t", "<Cmd>Grapple toggle_tags<CR>", desc = "Toggle a file" },
		{ prefix .. "e", "<Cmd>Grapple toggle_scopes<CR>", desc = "Select from tags" },
		{ prefix .. "s", "<Cmd>Grapple toggle_loaded<CR>", desc = "Select a project scope" },
		{
			prefix .. "x",
			"<Cmd>Grapple reset<CR>",
			desc = "Clear tags from current project",
		},
		{ "<C-n>", "<Cmd>Grapple cycle forward<CR>", desc = "Select next tag" },
		{ "<C-p>", "<Cmd>Grapple cycle backward<CR>", desc = "Select previous tag" },
	},
}

return M
