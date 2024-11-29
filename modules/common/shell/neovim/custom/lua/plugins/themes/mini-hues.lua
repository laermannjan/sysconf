return {
    'echasnovski/mini.hues',
    opts = {
        accent = 'bg',
        background = '#14252f',
        foreground = '#c1c8cc',
        n_hues = 8,
        plugins = {
            default = true,
        },
        saturation = 'mediumhigh',
    },
    config = function()
        if Config.theme == 'randomhue' then vim.cmd.colorscheme('randomhue') end
    end,
}
