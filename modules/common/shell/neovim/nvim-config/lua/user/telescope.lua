local M = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
		{
			"ahmedkhalf/project.nvim",
			lazy = false,
			config = function()
				require("project_nvim").setup()
			end,
		},
	},
	keys = {
		{ "<leader>fg", "<cmd>Telescope git_files show_untracked=true<CR>", desc = "find git files" },
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "find files" },
		-- {
		--	"<leader>fc",
		--	function()
		--		require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
		--	end,
		--	desc = "find in nvim config",
		--},
		{ "<leader>fc", "<cmd>Telescope find_files cwd=~/.config follow=true<CR>", desc = "find in XDG_CONFIG" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "recent files" },
		{ "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "find word in files" },
		{ "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "find selection in files", mode = "v" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "find help" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "find keymaps" },
		{ "<leader>fC", "<cmd>Telescope commands<CR>", desc = "find commands" },
		{ "<leader>fp", "<cmd>Telescope projects<CR>", desc = "find projects" },
		{ "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "find man pages" },
		{ "<leader>uc", "<cmd>Telescope colorscheme enable_preview=true<CR>", desc = "preview colorschemes" },
		{ "<leader>\\", "<cmd>Telescope<CR>", desc = "find telescope command" },
		{ "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "live grep" },

		{ "<leader><leader>", "<cmd>Telescope resume<CR>", desc = "resume last search" },

		{ "<leader>gB", "<cmd>Telescope git_branches<CR>", desc = "checkout git branch" },
		{ "<leader>go", "<cmd>Telescope git_status<CR>", desc = "open changed file" },
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "checkout git commit" },
		{ "<leader>gC", "<cmd>Telescope git_bcommits<CR>", desc = "checkout git commit for current file" },
	},
}

M.config = function()
	local trouble = require "trouble.providers.telescope"

	local open_with_trouble = function(...)
		return require("trouble.providers.telescope").open_with_trouble(...)
	end
	local find_files_no_ignore = function()
		local action_state = require "telescope.actions.state"
		local line = action_state.get_current_line()
		require("telescope.builtin").find_files {
			no_ignore = true,
			no_ignore_parents = true,
			default_text = line,
		}
	end
	local find_files_with_hidden = function()
		local action_state = require "telescope.actions.state"
		local line = action_state.get_current_line()
		require("telescope.builtin").find_files { hidden = true, default_text = line }
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "TelescopeResults",
		callback = function(ctx)
			vim.api.nvim_buf_call(ctx.buf, function()
				vim.fn.matchadd("TelescopeParent", "\t\t.*$")
				vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
			end)
		end,
	})

	local icons = require "user.icons"
	local actions = require "telescope.actions"

	local function filenameFirst(_, path)
		local tail = vim.fs.basename(path)
		local parent = vim.fs.dirname(path)
		if parent == "." then
			return tail
		end
		return string.format("%s\t\t%s", tail, parent)
	end

	require("telescope").setup {
		defaults = {
			mappings = {
				i = {
					["<c-t>"] = open_with_trouble,
					["<a-i>"] = find_files_no_ignore,
					["<a-h>"] = find_files_with_hidden,
				},
				n = { ["<c-t>"] = trouble.open_with_trouble },
			},
		},
		pickers = {
			find_files = {
				theme = "ivy",
				path_display = filenameFirst,
			},
		},
		extensions = {
			projects = {},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	}
end

return M
