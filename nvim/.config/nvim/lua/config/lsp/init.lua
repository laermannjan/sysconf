local M = {}

M.setup = function()

   local status_ok, lsp = pcall(require, "lsp-zero")
   if not status_ok then
      require("utils").warn("lsp-zerp could not be required.", "lsp-config")
      return
   end

   lsp.preset("recommended")

   require("config.lsp.cmp").setup()
   require("config.lsp.servers").setup()
   require("config.lsp.null-ls").setup()

   lsp.on_attach(function(client, bufnr)
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
