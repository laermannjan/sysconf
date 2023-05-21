return {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "b0o/SchemaStore.nvim",
    },
    opts = {
        pre_lsp_setup_hooks = {
            schemastore = function()
                require("lspconfig").jsonls.setup({
                    settings = {
                        json = {
                            schemas = vim.list_extend({
                                {
                                    description = "pyright config",
                                    fileMatch = { "pyrightconfig.json" },
                                    name = "pyrightconfig.json",
                                    url = "https://raw.githubusercontent.com/microsoft/pyright/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json",
                                },
                            }, require("schemastore").json.schemas({})),
                            validate = { enable = true },
                        },
                    },
                })

                require("lspconfig").yamlls.setup({
                    settings = {
                        yaml = {
                            schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                })
            end,
        },
    },
}
