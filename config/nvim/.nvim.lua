vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { disable = { 'missing-fields' } },
        }
    }
})
