local M = {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	-- dependencies = {
	-- 	"zbirenbaum/copilot-cmp",
	-- },
}

function M.config()
	do
		return
	end -- WARN: remove if owning a subscription again
	require("copilot").setup {
		panel = {
			keymap = {
				jump_next = "<c-j>",
				jump_prev = "<c-k>",
				accept = "<c-l>",
				refresh = "r",
				open = "<M-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = false, -- INFO:  <S-Tab> This is handled by cmp
				accept_word = "<M-Tab>",
				accept_line = false, -- INFO: <Tab> This is handled by cmp
				next = "<c-j>",
				prev = "<c-k>",
				dismiss = false, -- INFO: <C-e> This is handled by cmp
			},
		},
		filetypes = {
			markdown = true,
			help = false,
			gitcommit = false,
			gitrebase = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node",
	}

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "<c-s>", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

	-- require("copilot_cmp").setup()
end

return M
