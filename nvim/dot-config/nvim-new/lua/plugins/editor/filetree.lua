return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e",  "<cmd>Neotree toggle<cr>",                  "File explorer" },
            { "<leader>cs", "<cmd>Neotree toggle document_symbols<cr>", "Document Symbols explorer" },
        },
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            close_if_last_window = true,
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
                hijack_netrw_behavior = "open_current",
                filtered_items = {
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_by_name = {
                        "node_modules"
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        ".gitignore",
                        ".dockerignore",
                        ".docstr.yaml",
                        ".gitlab-ci.yaml",
                        ".pre-commit-config.yaml",
                        ".env",
                        ".envrc",
                        ".tool-versions",
                        ".rtx.conf"
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        ".DS_Store",
                        "thumbs.db"
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        ".null-ls_*",
                    },
                }
            }
        }
    }
}
