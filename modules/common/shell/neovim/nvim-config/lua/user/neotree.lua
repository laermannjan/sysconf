local M = {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require "neo-tree"
			end
		end
	end,
	keys = {
		{ "<leader>e", mode = { "n" }, "<cmd>Neotree toggle reveal_force_cwd<CR>", desc = "Neotree" },
	},
}

M.config = function(_, opts)
	local function on_move(data)
		require("user.utils").on_rename(data.source, data.destination)
	end

	local events = require "neo-tree.events"
	opts.event_handlers = opts.event_handlers or {}
	vim.list_extend(opts.event_handlers, {
		{ event = events.FILE_MOVED, handler = on_move },
		{ event = events.FILE_RENAMED, handler = on_move },
	})

	local icons = require "user.icons"
	-- vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = green }) --  File name when the git status is added. --
	-- vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = red }) -- File name when the git status is conflict.
	-- vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = red }) -- File name when the git status is deleted.
	-- vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#bbbbbb" }) -- File name when the git status is ignored.
	vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "DiagnosticWarning" }) -- File name when the git status is modified.
	vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { link = "DiagnosticWarning" }) -- Used for git unstaged symbol.
	vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { link = "DiagnosticInfo" }) -- File name when the git status is untracked.
	-- vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = green }) -- Used for git staged symbol.
	require("neo-tree").setup {
		close_if_last_window = true,
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			hijack_netrw_behavior = "open_current",
			bind_to_cwd = true,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		default_component_configs = {
			name = {
				use_git_status_colors = true,
			},
			git_status = {
				symbols = {
					-- Change type
					added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
					modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
					deleted = icons.git.deleted, -- this can only be used in the git_status source
					renamed = icons.git.renamed, -- this can only be used in the git_status source
					-- Status type
					untracked = icons.git.untracked,
					ignored = icons.git.ignored,
					unstaged = icons.git.unstaged,
					staged = icons.git.staged,
					conflict = icons.git.unmerged,
				},
			},
		},
	}
end

return M
