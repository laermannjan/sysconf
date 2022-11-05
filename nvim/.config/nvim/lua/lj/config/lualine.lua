local ok, lualine = pcall(require, "lualine")
if not ok then
	vim.notify("Lualine could not be required!")
	return
end

local navic_ok, navic = pcall(require, "nvim-navic")
if not navic_ok then
	vim.notify("Navic could not be required!")
	return
end

lualine.setup({
	options = {
		globalstatus = true,
		-- section_separators = { left = "", right = "" },
		-- component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_c = {
			{ navic.get_location },
		},
	},
})
