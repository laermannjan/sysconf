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
            { 'kawre/neotab.nvim', opts = { tabkey = '', act_as_tab = false } },
        },
        opts = {
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'select_and_accept', 'snippet_forward', function(cmp) require('neotab').tabout() end, 'fallback' },
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                cmdline = { preset = 'default' },
            },
            completion = {
                list = { selection = { preselect = false, auto_insert = false } },
                accept = { auto_brackets = { enabled = true } },
                menu = { draw = { treesitter = { 'lsp' } } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
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
                    copilot = { name = 'copilot', module = 'blink-cmp-copilot', score_offset = 100, async = true },
                    beancount = { name = 'beancount', module = 'blink.compat.source' },
                },
            },
        },
    },
}
