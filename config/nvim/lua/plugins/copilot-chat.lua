return {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
        local user = vim.env.USER or 'User'
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
            auto_insert_mode = true,
            question_header = '  ' .. user .. ' ',
            answer_header = '  Copilot ',
            window = {
                width = 0.4,
            },
        }
    end,
    keys = {
        { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
        {
            '<leader>A',
            function() return require('CopilotChat').toggle() end,
            desc = 'Copilot Chat',
            mode = { 'n', 'v' },
        },
        -- Show prompts actions with telescope
        -- { '<leader>ap', M.pick('prompt'), desc = 'Prompt Actions (CopilotChat)', mode = { 'n', 'v' } },
    },
    config = function(_, opts)
        local chat = require('CopilotChat')

        vim.api.nvim_create_autocmd('BufEnter', {
            pattern = 'copilot-chat',
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false
            end,
        })

        chat.setup(opts)
    end,
}