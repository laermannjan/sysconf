return {
    {
        'echasnovski/mini.files',
        enabled = true,
        version = false,
        keys = {
            { "-", "<cmd>lua MiniFiles.open()<cr>", "Open Files Navigator" },
        },
        opts = {},
    },

    {
        'stevearc/oil.nvim',
        enabled = false,
        opts = {},
        keys = {
            { "-", "<cmd>Oil<cr>", "Open Files Navigator" },
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
