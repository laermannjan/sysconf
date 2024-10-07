local M = {
    "echasnovski/mini.ai",
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter",
    }
}

M.config = function()
        local gen_spec = require('mini.ai').gen_spec
        require('mini.ai').setup {
            custom_textobjects = {
                F = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
                ["="] = gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.rhs' }),
            }
        }
end

return M
