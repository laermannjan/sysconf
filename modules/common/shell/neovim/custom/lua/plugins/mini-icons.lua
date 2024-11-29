return {
    'echasnovski/mini.icons',
    opts = true,
    config = function(_, opts)
        require('mini.icons').setup(opts)
        MiniIcons.mock_nvim_web_devicons()
        -- MiniIcons.tweak_lsp_kind()
    end,
}
