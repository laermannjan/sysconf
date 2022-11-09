table.insert(lvim.plugins, { "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
        vim.defer_fn(function()
            require("copilot").setup {
                plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
            }
        end, 100)
    end,
})

table.insert(lvim.plugins, { "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
    config = function()
        require("copilot_cmp").setup {
            formatters = {
                insert_text = require("copilot_cmp.format").remove_existing,
            },
        }
    end,
})
lvim.builtin.which_key.mappings['lc'] = { "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<cr>",
    "Get Copilot Suggestions" }
-- Can not be placed into the config method of the plugins.
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
