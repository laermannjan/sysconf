return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        opts = { style = "night" }, -- night | storm | day
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        priority = 1000,
        opts = { theme = "wave" }, -- wave | dragon | lotus
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = true,
        opts = { variant = "main" }, -- main | moon | dawn
    },
    { 'talha-akram/noctis.nvim', lazy = true }

}
