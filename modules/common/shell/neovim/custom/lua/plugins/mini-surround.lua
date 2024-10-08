
local M = {
    "echasnovski/mini.surround",
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter",
    }
}

M.config = function()
local ts_input = require('mini.surround').gen_spec.input.treesitter
    require('mini.surround').setup({
        suffix_last = "p", -- instead of default l
        custom_surroundings = {
            -- Use treesitter to search for function call
            f = {
                input = ts_input({ outer = '@call.outer', inner = '@call.inner' })
            },
            F = {
                input = ts_input({ outer = '@function.outer', inner = '@function.inner' })
            },
        }
    })
end

return M
