require('conform').setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        go = { 'goimports', 'gofumpt' },
        nix = { 'nixfmt' },
    },
    format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 500,
    },
    default_format_opts = {
        lsp_format = 'fallback',
    },
})
