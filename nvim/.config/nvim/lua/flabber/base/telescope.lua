return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>ff",
                function()
                    local ts = require("telescope.builtin")
                    local opts = {}
                    local git_files_ok = pcall(ts.git_files, opts)
                    if not git_files_ok then
                        ts.find_files(opts)
                    end
                end,
                "Find files",
            },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", "Find help" },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>", "Find keymaps" },
            { "<leader>fm", "<cmd>Telescope man_pages<CR>", "Find man pages" },
            { "<leader>fc", "<cmd>Telescope commands<CR>", "Find man pages" },
            {
                "<leader>fn",
                function()
                    require("telescope").extensions.notify.notify()
                end,
                desc = "Find notifications",
            },
            {
                "<leader>/",
                "<cmd>Telescope live_grep<CR>",
                desc = "Find words (grep)",
            },
            {
                "<leader>ls",
                function()
                    local aerial_avail, _ = pcall(require, "aerial")
                    if aerial_avail then
                        require("telescope").extensions.aerial.aerial()
                    else
                        require("telescope.builtin").lsp_document_symbols()
                    end
                end,
                desc = "Search symbols",
            },
            {
                "<leader>lS",
                function()
                    require("aerial").toggle()
                end,
                desc = "Symbols outline",
            },
            {
                "<leader>ut",
                function()
                    require("telescope.builtin").colorscheme({ enable_preview = true })
                end,
                desc = "Find themes",
            },
        },
        opts = {
            extensions = {},
        },

        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            for ext, _ in pairs(opts.extensions) do
                telescope.load_extension(ext)
            end
        end,
    },
}
