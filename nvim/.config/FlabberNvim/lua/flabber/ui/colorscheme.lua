local colorscheme = vim.g.colorscheme or "rose-pine"

local M = {}

M.colorschemes = {
    { "folke/tokyonight.nvim", name = "tokyonight", opts = { style = "night" } },
    { "rose-pine/neovim", name = "rose-pine", opts = { variant = "auto" } }, -- moon
    { "ellisonleao/gruvbox.nvim", name = "gruvbox" },
    { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "moccha" } },
}

for i, value in ipairs(M.colorschemes) do
    if value.name == colorscheme then
        -- Prioritize colorscheme
        M.colorschemes[i].lazy = false
        M.colorschemes[i].priority = 1000

        if value.config == nil then
            M.colorschemes[i].config = function(_, opts)
                require(colorscheme).setup(opts)
                -- require(colorscheme).load()
                vim.cmd("colorscheme " .. colorscheme)
            end
        end

        break
    else
        M.colorschemes[i].lazy = true
    end
end

return M.colorschemes
