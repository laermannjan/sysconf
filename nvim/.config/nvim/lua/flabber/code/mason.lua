return {
    "williamboman/mason.nvim",
    build = function()
        pcall(vim.cmd, "MasonUpdate")
    end,
    opts = {
        ensure_installed = {}, -- to be overriden in pde modules
    },
}
