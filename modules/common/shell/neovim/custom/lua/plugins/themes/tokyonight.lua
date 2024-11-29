return {
    'folke/tokyonight.nvim',
    opts = { style = 'night' },
    priority = 1000,
    config = function(opts)
        require('tokyonight').setup(opts)
        if Config.theme == 'tokyonight' then vim.cmd.colorscheme('tokyonight') end
    end,
}
