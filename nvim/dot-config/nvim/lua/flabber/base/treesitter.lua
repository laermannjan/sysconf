return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            sync_install = false,
            ensure_installed = {
                "bash",
                "dockerfile",
                "html",
                "regex",
                "vim",
                "vimdoc",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                -- deduplicate the list
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts) -- important to call on .configs
        end,
    },
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
        mode = "topline",
    },
}
