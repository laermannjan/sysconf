return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	enabled = false,
	config = function()
		require("chatgpt").setup({
			api_key_cmd = "get-openai-api-key.sh",
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
