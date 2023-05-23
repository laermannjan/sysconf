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
        vim.notify("checking " .. bin)
        if vim.fn.executable(bin) == 1 then
            vim.notify("found " .. bin)
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
        { "<leader>TT", "<cmd>ToggleTerm<cr>", desc = "Floating terminal" },
        {
            "<leader>Tp",
            function()
                tterm(get_bin({ "python", "python3" }))
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
            "<leader>Tg",
            function()
                tterm(get_bin({ "lazygit" }))
            end,
            desc = "Lazygit",
        },
        {
            "<leader>Td",
            function()
                tterm(get_bin({ "lazydocker" }))
            end,
            desc = "Lazydocker",
        },
        {
            "<leader>TP",
            function()
                tterm(get_bin({ "btop", "btm" }))
            end,
            desc = "Processes (top-like)",
        },
        {
            "<leader>Tn",
            function()
                tterm(get_bin({ "node" }))
            end,
            desc = "Node",
        },
        {
            "<leader>Tu",
            function()
                tterm(get_bin({ "gdu" }))
            end,
            desc = "Disk usage (gdu)",
        },
        {
            "<leader>Tk",
            function()
                tterm(get_bin({ "lazykube" }))
            end,
            desc = "Lazykube",
        },
    },
}
