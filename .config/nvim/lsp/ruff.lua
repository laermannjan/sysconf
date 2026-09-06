return {
    init_options = {
        settings = {
            fixAll = true,
            organizeImports = true,
            showSyntaxErrors = true,
        },
    },
    on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end,
}
