return {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
        { "<leader>gS", ":Neogit<CR>", desc = "Git status" },
    },
}
