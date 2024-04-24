local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"AndreM222/copilot-lualine",
	},
}

M.config = function()
	local icons = require "user.icons"
	local diff = {
		"diff",
		colored = false,
		symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
	}

	local clients_lsp = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.buf_get_clients(bufnr)

		local buf_ft = vim.bo.filetype
		local client_names = {}

		for _, client in pairs(clients) do
			if client.name ~= "copilot" and client.name ~= "null-ls" then
				table.insert(client_names, client.name)
			end
		end

		-- null-ls sources
		local null_ls_ok, null_ls = pcall(require, "null-ls")
		if null_ls_ok then
			local sources = null_ls.get_sources()
			for _, source in ipairs(sources) do
				if source._validated then
					for ft_name, ft_active in pairs(source.filetypes) do
						if ft_name == buf_ft and ft_active then
							table.insert(client_names, source.name)
						end
					end
				end
			end
		end

		return "\u{f085} [" .. table.concat(client_names, " ") .. "]"
	end

	require("lualine").setup {
		options = {
			theme = "powerline",
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },

			ignore_focus = { "NvimTree", "Neotree" },
		},
		sections = {
			lualine_a = { { "branch", icon = "" } },
			lualine_b = {},
			lualine_c = { "diff", "diagnostics", "filename" },
			-- lualine_x = { copilot },
			-- lualine_y = { "filetype" },
			-- lualine_z = { "progress" },
			-- lualine_a = { "mode" },
			-- lualine_a = {},
			-- lualine_b = { "branch" },
			-- lualine_x = { diff, "copilot", filetype },
			lualine_x = { clients_lsp, "encoding", "copilot", "filetype" },
			lualine_y = { "progress" },
			lualine_z = {},
		},
		-- extensions = { "quickfix", "man", "fugitive", "oil" },
		extensions = { "quickfix", "man", "fugitive" },
	}
end

return M
