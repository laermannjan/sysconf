local M = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
}

M.config = function()
    if vim.g.colorscheme == "tokyonight" then
        require("tokyonight").setup({
            style = "night",
        })
        vim.cmd.colorscheme(vim.g.colorscheme)
    end
end

return M
