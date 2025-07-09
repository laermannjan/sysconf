return {
    'mason-org/mason-lspconfig.nvim',
    opts = {
        ensure_installed = { 'shfmt' },
        automatic_enable = {
            exclude = {},
        },
    },
    opts_extend = { 'ensure_installed', 'automatic_enable.exclude' },
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'neovim/nvim-lspconfig',
    },
    config = function(_, opts)
        local lsps = {}
        local mr = require('mason-registry')
        mr.refresh(function()
            for _, tool in ipairs(opts.ensure_installed) do
                if not mr.has_package(tool) then
                    -- append tool to lsps
                    vim.list_extend(lsps, { tool })
                else
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end
        end)
        opts.ensure_installed = lsps
        require('mason-lspconfig').setup(opts)
    end,
}
