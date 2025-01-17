return {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
        suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = {
                accept = false, -- handled by nvim-cmp / blink.cmp
                next = '<M-]>',
                prev = '<M-[>',
            },
        },
        panel = { enabled = false },
        filetypes = {
            beancount = false,
            markdown = true,
            help = true,
        },
    },
}
