return {
    'echasnovski/mini.ai',
    dependencies = {
        { 'echasnovski/mini.extra', opts = true },
    },
    opts = function(_, opts)
        opts = opts or {}

        local ai = require('mini.ai')
        return vim.tbl_deep_extend('force', opts, {
            custom_textobjects = {
                B = require('mini.extra').gen_ai_spec.buffer(),
                F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
                ['='] = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.rhs' }),
            },
        })
    end,
}
