return {
    "rcarriga/nvim-notify",
    config = function ()
        vim.notify = require("notify")
        local ok, _ = pcall(require, 'telescope')
        local rhs = ok and ":Telescope notify<cr>" or ":Notifications<cr>"
        vim.keymap.set("n", "<leader>fn", rhs, { desc = "find notifications"})
    end
}
