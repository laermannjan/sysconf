return {
    {
        'echasnovski/mini.statusline',
        enabled = false,
    },
    {
        'rebelot/heirline.nvim',
        dependencies = { 'Zeioth/heirline-components.nvim' },
        opts = function()
            local lib = require('heirline-components.all')
            return {
                statusline = { -- UI statusbar
                    hl = { fg = 'fg', bg = 'bg' },
                    lib.component.mode(),
                    lib.component.git_branch(),
                    lib.component.file_info(),
                    lib.component.git_diff(),
                    lib.component.diagnostics(),
                    lib.component.fill(),
                    lib.component.file_info({ filename = { modify = ':~:.' }, filetype = false }),
                    lib.component.fill(),
                    lib.component.lsp(),
                    lib.component.nav(),
                    lib.component.mode({ surround = { separator = 'right' } }),
                },
            }
        end,
        config = function(_, opts)
            local heirline = require('heirline')
            local heirline_components = require('heirline-components.all')

            -- Setup
            heirline_components.init.subscribe_to_events()
            heirline.load_colors(heirline_components.hl.get_colors())
            heirline.setup(opts)
        end,
    },
}
