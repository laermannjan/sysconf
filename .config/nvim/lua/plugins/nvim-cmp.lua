return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'aznhe21/actions-preview.nvim',
        {
            'L3MON4D3/LuaSnip',
            dependencies = { 'saadparwaiz1/cmp_luasnip' },
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        },
    },
    opts = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        return {
            sources = {
                -- { name = "copilot", priority = 10000 },
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'lazydev', group_index = 0 },
                { name = 'nvim_lsp_signature_help' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer', keyword_length = 3 },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
            mapping = cmp.mapping.preset.insert({

                ['<C-p>'] = cmp.mapping(function(fallback)
                    local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif ok_copilot and copilot.is_visible() then
                        copilot.prev()
                    else
                        fallback()
                    end
                end, { 'i', 'c' }),
                ['<C-n>'] = cmp.mapping(function(fallback)
                    local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ok_copilot and copilot.is_visible() then
                        copilot.next()
                    else
                        fallback()
                    end
                end, { 'i', 'c' }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-2),
                ['<C-d>'] = cmp.mapping.scroll_docs(2),
                ['<C-e>'] = cmp.mapping(function(fallback)
                    local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
                    if cmp.visible() then
                        cmp.abort()
                        cmp.close()
                    elseif ok_copilot and copilot.is_visible() then
                        copilot.dismiss()
                    else
                        fallback()
                    end
                end, { 'i', 'c' }),
                ['<S-CR>'] = cmp.mapping(function(fallback)
                    local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
                    if ok_copilot and copilot.is_visible() then
                        copilot.accept()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local ok_copilot, copilot = pcall(require, 'copilot.suggestion')
                    local ok_neotab, neotab = pcall(require, 'neotab')

                    if ok_copilot and copilot.is_visible() then
                        copilot.accept_line()
                    elseif cmp.visible() then
                        cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif ok_neotab then
                        neotab.tabout()
                    else
                        fallback()
                    end
                end, {
                    'i',
                    's',
                }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {
                    'i',
                    's',
                }),
            }),
            -- note: if you are going to use lsp-kind (another plugin)
            -- replace the line below with the function from lsp-kind
            -- formatting = lsp_zero.cmp_format({ details = true }),
        }
    end,
}
