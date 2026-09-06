return {
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                autoImportCompletions = true,
                typeCheckingMode = 'off',
                -- ignore = { "*" },
            },
        },
    },
}
