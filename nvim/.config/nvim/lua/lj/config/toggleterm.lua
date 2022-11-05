local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	vim.notify("ToggleTerm could not be required!")
end

toggleterm.setup({
	open_mapping = [[<c-\>]],
})
