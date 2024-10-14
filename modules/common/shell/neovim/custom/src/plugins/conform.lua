require('conform').setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        go = { 'goimports', 'gofumpt' },
    },
    format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 500,
    },
})
