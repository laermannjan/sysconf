return {
    "ThePrimeagen/harpoon",
    config = function(_, opts)
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>'", mark.add_file, { desc = "Add to Harpoon" })
        vim.keymap.set("n", "<leader>0", ui.toggle_quick_menu, { desc = "Show Harpoon" })
        vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon Buffer 1" })
        vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon Buffer 2" })
        vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon Buffer 3" })
        vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon Buffer 4" })
        vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { desc = "Harpoon Buffer 5" })
    end,
}
