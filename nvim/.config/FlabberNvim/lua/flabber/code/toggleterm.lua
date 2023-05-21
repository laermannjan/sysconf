local tterm = function(opts)
    -- create / toggle ToggleTerm instance with cmd/opts
    if type(opts) == "string" then
        opts = { cmd = opts, hidden = true }
    end
    require("toggleterm.terminal").Terminal:new(opts):toggle()
end

local get_bin = function(bins)
    -- check whether binary is in $PATH
    for _, bin in pairs(bins) do
        if vim.fn.executable(bin) == 1 then
            return bin
        end
    end
end

return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
        size = 10,
        on_create = function()
            vim.opt.foldcolumn = "0"
            vim.opt.signcolumn = "no"
        end,
        open_mapping = [[<F7>]],
        shading_factor = 2,
        direction = "float",
        float_opts = {
            border = "curved",
            highlights = { border = "Normal", background = "Normal" },
        },
    },
    keys = {
        { "<F7>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Floating terminal" },
        {
            "<leader>tp",
            function()
                tterm(get_bin({ "ipython", "python", "python3" }))
            end,
            desc = "Python REPL",
        },
        {
            "<leader>gg",
            function()
                tterm(get_bin({ "lazygit" }))
            end,
            desc = "Lazygit",
        },
        {
            "<leader>tg",
            function()
                tterm(get_bin({ "lazygit" }))
            end,
            desc = "Lazygit",
        },
        {
            "<leader>td",
            function()
                tterm(get_bin({ "lazydocker" }))
            end,
            desc = "Lazydocker",
        },
        {
            "<leader>tp",
            function()
                tterm(get_bin({ "btop", "btm" }))
            end,
            desc = "Processes (top-like)",
        },
        {
            "<leader>tn",
            function()
                tterm(get_bin({ "node" }))
            end,
            desc = "Node",
        },
        {
            "<leader>tu",
            function()
                tterm(get_bin({ "gdu" }))
            end,
            desc = "Disk usage (gdu)",
        },
        {
            "<leader>tk",
            function()
                tterm(get_bin({ "lazykube" }))
            end,
            desc = "Lazykube",
        },
    },
}
