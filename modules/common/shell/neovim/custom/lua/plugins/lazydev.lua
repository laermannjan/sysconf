return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
            },
        },
    },
    -- Add lazydev source to cmp
    {
        'hrsh7th/nvim-cmp',
        optional = true,
        opts = function(_, opts) table.insert(opts.sources, { name = 'lazydev', group_index = 0 }) end,
    },

    -- Add lazydev source to blink
    {
        'saghen/blink.cmp',
        optional = true,
        opts = {
            sources = {
                completion = {
                    -- add lazydev to your completion providers
                    enabled_providers = { 'lazydev' },
                },
                providers = {
                    lsp = {
                        -- dont show LuaLS require statements when lazydev has items
                        fallback_for = { 'lazydev' },
                    },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                    },
                },
            },
        },
    },
}
