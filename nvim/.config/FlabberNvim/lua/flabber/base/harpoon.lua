return {
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- stylua: ignore
        keys = {
            { "<leader>fm", function() require("harpoon.mark").add_file() end,        desc = "Mark file (harpoon)", },
            { "<leader>fh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon Menu", },
            { "<C-S-q>",    function() require("harpoon.ui").nav_file(1) end,         desc = "Jump to 1st harpoon", },
            { "<C-S-w>",    function() require("harpoon.ui").nav_file(2) end,         desc = "Jump to 2nd harpoon", },
            { "<C-S-e>",    function() require("harpoon.ui").nav_file(3) end,         desc = "Jump to 3rd harpoon", },
            { "<C-S-r>",    function() require("harpoon.ui").nav_file(4) end,         desc = "Jump to 4th harpoon", },
        },
    },
}
