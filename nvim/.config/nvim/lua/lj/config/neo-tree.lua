local ok, nt = pcall(require, "neo-tree")
if not ok then
	vim.notify("Neo-tree could not be required!")
	return
end

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

nt.setup({
	-- source_selector = {
	--     winbar = true,
	--     statusline = false,
	-- },
	-- sort_case_insensitive = true,
	-- popup_border_style = "rounded",
	-- close_if_last_window = true,
})
