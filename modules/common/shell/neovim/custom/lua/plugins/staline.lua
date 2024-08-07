local M = {
    "tamton-aquib/staline.nvim",
    opts = {
        -- stylua: ignore
		sections = {
            left = { '▊', ' ',{ 'StalineFile', 'file_name' },'mode', 'file_name', 'file_size', 'branch'  },
            mid = {"lsp"},
            right = { 'lsp_name', 'cool_symbol', '-line_column' },
		},
    },
}

return M
