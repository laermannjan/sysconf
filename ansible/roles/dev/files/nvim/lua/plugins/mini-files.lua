return {
    'echasnovski/mini.files',
    version = false,
    keys = {
        {
            '<leader>e',
            function()
                if not MiniFiles.close() then
                    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
                    MiniFiles.reveal_cwd()
                end
            end,
            desc = 'Explorer',
        },
    },
    opts = {
        windows = { preview = true, width_preview = 80 },
        mappings = {
            go_in = '',
            go_in_plus = '<cr>',
            go_out = '',
            go_out_plus = '<bs>',
            reset = '',
        },
    },
}
