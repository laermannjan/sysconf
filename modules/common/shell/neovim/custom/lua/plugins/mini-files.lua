return {
    'echasnovski/mini.files',
    keys = {
        { '<leader>fe', "<cmd>lua require('mini.files').open()", 'Explorer' },
    },
    opts = {
        windows = { preview = true, width_preview = 80 },
        mappings = {
            go_in = '',
            go_in_plus = '<cr>',
            go_out = '',
            go_out_plus = '<bs>',
            reset = '',
            close = '<esc>',
        },
    },
}
