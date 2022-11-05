local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
    vim.notify("Tokyonight theme could not be found!")
    return

end

tokyonight.setup({
    style = "night", -- night, storm, moon, day
})

vim.cmd("colorscheme tokyonight")
