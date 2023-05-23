local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        { import = "flabber.base" },
        { import = "flabber.code" },
        { import = "flabber.ui" },
        { import = "flabber.pde" },
    },
    install = { missing = true, colorscheme = { "tokyonight", "rose-pine", "gruvbox", "habamax" } },
})