local M = {
	"nvim-treesitter/nvim-treesitter",
	-- event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",

	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- event = "VeryLazy",
		},
	},
}

M.config = function()
	require("nvim-treesitter.configs").setup {
		ensure_installed = {
			"c",
			"cpp",
			"go",
			"lua",
			"python",
			"rust",
			"tsx",
			"javascript",
			"typescript",
			"vimdoc",
			"vim",
			"bash",
			"markdown",
		},

		auto_install = true,
		ignore_install = {},
		sync_install = false,
		modules = {},

		highlight = { enable = true },
		indent = { enable = true },
		-- incremental_selection = {
		-- 	enable = true,
		-- 	keymaps = {
		-- 		init_selection = "<c-space>",
		-- 		node_incremental = "<c-space>",
		-- 		scope_incremental = "<c-s>",
		-- 		node_decremental = "<M-space>",
		-- 	},
		-- },
		-- autopairs = { enable = true },
		-- textobjects = {
		-- 	select = {
		-- 		enable = true,
		-- 		-- Automatically jump forward to textobj, similar to targets.vim
		-- 		lookahead = true,
		-- 		keymaps = {
		-- 			-- You can use the capture groups defined in textobjects.scm
		-- 			["af"] = "@function.outer",
		-- 			["if"] = "@function.inner",
		-- 			["ac"] = "@call.outer",
		-- 			["ic"] = "@call.inner",
		-- 			["aa"] = "@parameter.outer",
		-- 			["ia"] = "@parameter.inner",
		-- 			["al"] = "@loop.outer",
		-- 			["il"] = "@loop.inner",
		-- 			["ai"] = "@conditional.outer",
		-- 			["ii"] = "@conditional.inner",
		-- 			["a/"] = "@comment.outer",
		-- 			["i/"] = "@comment.inner",
		-- 			["aA"] = "@attribute.outer",
		-- 			["iA"] = "@attribute.inner",
		-- 		},
		-- 	},
		-- 	move = {
		-- 		enable = true,
		-- 		set_jumps = true, -- whether to set jumps in the jumplist
		-- 		goto_next_start = {
		-- 			["]f"] = "@function.outer",
		-- 			["]c"] = "@class.outer",
		-- 		},
		-- 		goto_next_end = {
		-- 			["]F"] = "@function.outer",
		-- 			["]C"] = "@class.outer",
		-- 		},
		-- 		goto_previous_start = {
		-- 			["[f"] = "@function.outer",
		-- 			["[c"] = "@class.outer",
		-- 		},
		-- 		goto_previous_end = {
		-- 			["[F"] = "@function.outer",
		-- 			["[C"] = "@class.outer",
		-- 		},
		-- 	},
		-- 	swap = {
		-- 		enable = true,
		-- 		swap_next = {
		-- 			[">a"] = "@parameter.inner",
		-- 			[">A"] = "@parameter.inner",
		-- 		},
		-- 		swap_previous = {
		-- 			["<a"] = "@parameter.inner",
		-- 			["<A"] = "@parameter.inner",
		-- 		},
		-- 	},
		-- },
	}
end

return M
