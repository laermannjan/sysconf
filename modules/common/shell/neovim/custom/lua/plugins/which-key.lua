local M = {
	"folke/which-key.nvim",
}

M.config = function()
	local wk = require "which-key"
	wk.setup()
	wk.register {
		["<leader>f"] = { name = "file" },
		["<leader>g"] = { name = "git" },
		["<leader>u"] = { name = "(ui) toggles" },
		["<leader>c"] = { name = "code" },
		["<leader>t"] = { name = "test" },
	}
end

return M
