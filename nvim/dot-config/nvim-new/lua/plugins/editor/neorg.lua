return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = false,
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp"
                    }
                },                  -- Loads default behaviour
                -- ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/Documents/Notes",
                        },
                        index = "main.org"
                    },
                },
            },
        }
    end,
}
