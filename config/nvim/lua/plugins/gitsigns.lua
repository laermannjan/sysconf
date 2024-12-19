if not vim.g.enable_gitsigns ~= false then return {} end

return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            attach_to_untracked = true,
            current_line_blame = true,
        },
    },
    {
        'mini.diff',
        enabled = false,
    },
}
