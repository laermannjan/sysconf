return {
    {
        'hrsh7th/nvim-cmp',
        enabled = false,
    },
    {
        'saghen/blink.cmp',
        version = 'v0.*',
        dependencies = {
            { 'saghen/blink.compat', version = '*', opts = true },
            'rafamadriz/friendly-snippets',
            'crispgm/cmp-beancount',
            'giuxtaposition/blink-cmp-copilot',
            'zbirenbaum/copilot.lua',
            { 'kawre/neotab.nvim', opts = true },
        },
        opts = {
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'select_and_accept', 'snippet_forward', function(cmp) require('neotab').tabout() end, 'fallback' },
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
            },
            completion = {
                list = { selection = 'manual' },
                accept = { auto_brackets = { enabled = true } },
                documentation = { auto_show = true },
                ghost_text = { enabled = true },
            },
            signature = { enabled = true },
            sources = {
                -- add lazydev to your completion providers
                default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'copilot' },
                providers = {
                    -- dont show LuaLS require statements when lazydev has items
                    lsp = { fallbacks = { 'lazydev' } },
                    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
                    copilot = { name = 'copilot', module = 'blink-cmp-copilot' },
                    beancount = { name = 'beancount', module = 'blink.compat.source' },
                },
            },
        },
    },
}
