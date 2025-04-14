return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = '${3rd}/love2d/library', words = { 'love' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
            },
        },
    },
    { 'neovim/nvim-lspconfig' },
    {
        'williamboman/mason.nvim',
        -- cmd = 'Mason',
        build = ':MasonUpdate',
        opts = {
            ensure_installed = {
                'stylua',
                'shfmt',
            },
        },
        opts_extend = { 'ensure_installed' },
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end)
        end,
    },
}
