local lint = require('lint')
lint.linters_by_ft = {
    python = { 'mypy' },
}

lint.try_lint() -- start linter immediately
local timer = vim.uv.new_timer()
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('auto_lint', { clear = true }),
    desc = 'Automatically try linting',
    callback = function()
        -- try to lint repeatedly, subsequent calls will cancel the ones before
        timer:start(100, 0, function()
            timer:stop()
            vim.schedule(lint.try_lint)
        end)
    end,
})
