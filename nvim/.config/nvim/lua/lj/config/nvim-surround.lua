local ok, surround = pcall(require, "nvim-surround")
if not ok then
    vim.notify("Nvim-surround could not be required!")
    return
end

surround.setup()
