local M = {}

M.setup = function()

   local status_ok, lsp = pcall(require, "lsp-zero")
   if not status_ok then
      require("utils").warn("lsp-zerp could not be required.", "lsp-config")
      return
   end

   lsp.preset("recommended")
   lsp.set_preferences({
      set_lsp_keymaps = false
   })

   require("config.lsp.cmp").setup()
   require("config.lsp.servers").setup()
   require("config.lsp.null-ls").setup()

   lsp.on_attach(function(client, bufnr)
      -- keymaps
      local fmt = function(cmd) return function(str) return cmd:format(str) end end

      local map = function(m, lhs, rhs)
         local opts = { noremap = true, silent = true }
         vim.api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
      end

      local lspf = fmt('<cmd>lua vim.lsp.%s<cr>')
      local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')

      map('n', 'K', lspf 'buf.hover()')
      -- map('n', 'gd', lspf 'buf.definition()')
      map('n', 'gd', '<cmd>TroubleToggle lsp_definitions<cr>')
      map('n', 'gD', lspf 'buf.declaration()')
      map('n', 'gi', lspf 'buf.implementation()')
      -- map('n', 'go', lspf 'buf.type_definition()')
      map('n', 'gi', '<cmd>TroubleToggle lsp_type_definitions')
      -- map('n', 'gr', lspf 'buf.references()')
      map('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>')
      map('n', '<F2>', lspf 'buf.rename()')
      map('n', '<F4>', lspf 'buf.code_action()')
      map('x', '<F4>', lspf 'buf.range_code_action()')

      map('n', '<C-k>', lspf 'buf.signature_help()')

      map('n', 'gl', diagnostic 'open_float()')
      map('n', '[d', diagnostic 'goto_prev()')
      map('n', ']d', diagnostic 'goto_next()')
      -- add code context (breadcrumbs) with navic
      if client.server_capabilities.documentSymbolProvider then
         local navic_present, navic = pcall(require, "nvim-navic")
         if not navic_present then
            require("utils").warn("nvim-navic could not be required.", "lsp-config")
            return
         end
         navic.attach(client, bufnr)
      end

      -- auto format on save
      local present, lsp_format = pcall(require, "lsp-format")
      if not present then
         require("utils").warn("lsp-format could not be required.")
         return
      end
      lsp_format.on_attach(client)
   end)

   lsp.ensure_installed({
      'tsserver',
      'eslint',
      'sumneko_lua',
      'pyright',
      -- 'debugpy',
      'rust_analyzer',
   })

   lsp.setup()
   lsp.nvim_workspace() -- enable lsp for nvim config
end

return M
