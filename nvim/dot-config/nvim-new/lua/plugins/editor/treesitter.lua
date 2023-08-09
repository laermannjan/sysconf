return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            "python",
            "rust",
            "markdown",
            "markdown_inline",
            "html",
            "css",
            "javascript",
            "typescript",
            "regex",
            "lua",
            "bash",
            "fish",
            "yaml",
            "json",


        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
