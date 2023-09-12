return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    keys = {
        {
            "<leader>ff",
            function()
                local builtin = ""
                local opts = {}
                -- TODO: use LazyVim Util.get_root like function here
                if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
                    opts.show_untracked = true
                    builtin = "git_files"
                else
                    builtin = "find_files"
                end
                require("telescope.builtin")[builtin](opts)
            end,
            "Find files",
        },
        {
            "<leader>ss",
            function()
                require("telescope.builtin").lsp_document_symbols({
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    }
                })
            end,
            "Search Symbols"
        },
        {
            "<leader>/",
            function()
                require("telescope.builtin").live_grep()
            end
        }
    }
}
