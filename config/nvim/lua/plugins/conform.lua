return {
    'stevearc/conform.nvim',
    opts = {
        -- Map of filetype to formatters
        formatters_by_ft = {
            python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
            lua = { 'stylua' },
            javascript = { 'prettier' },
            json = { 'prettier' },
            go = { 'goimports', 'gofumpt' },
            nix = { 'nixfmt' },
            http = { 'kulala-fmt' },
            just = { 'just' },
            sql = { 'sql_formatter' },
            yaml = { 'yamlfmt' },
            rust = { 'rustfmt' },
        },
        format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_format = 'fallback',
            timeout_ms = 500,
        },
        default_format_opts = {
            lsp_format = 'fallback',
        },
    },
}
