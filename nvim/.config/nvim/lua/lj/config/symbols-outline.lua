local ok, outline = pcall(require, "symbols-outline")
if not ok then
	vim.notify("symbols-outline could not be required!")
	return
end

outline.setup()
