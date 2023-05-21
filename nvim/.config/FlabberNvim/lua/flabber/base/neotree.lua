return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
        end,
        opts = {
            close_if_last_window = true,
            open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
            mappings = {
                ["<cr>"] = "open_drop",
            },

            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        --auto close
                        require("neo-tree").close_all()
                    end,
                },
            },
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle explorer" },
            {
                "<leader>o",
                function()
                    if vim.bo.filetype == "neo-tree" then
                        vim.cmd.wincmd("p")
                    else
                        vim.cmd.Neotree("focus")
                    end
                end,
                desc = "Toggle Explorer Focus",
            },
        },
    },
}
