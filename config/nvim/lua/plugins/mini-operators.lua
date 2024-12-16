local op_prefix = ','
return {
    'echasnovski/mini.operators',
    opts = {
        evaluate = { prefix = op_prefix .. '=' },
        exchange = { prefix = op_prefix .. 'x' },
        multiply = { prefix = op_prefix .. 'm' },
        replace = { prefix = op_prefix .. 'r' },
        sort = { prefix = op_prefix .. 's' },
    },
}
