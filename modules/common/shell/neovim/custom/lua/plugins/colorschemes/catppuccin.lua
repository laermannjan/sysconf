local M = {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    opts = {
        --
    },
}

M.config = function(_, opts)
    if
        vim.tbl_contains(
            { "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha" },
            vim.g.colorscheme
        )
    then
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme(vim.g.colorscheme)
    end
end

return M
