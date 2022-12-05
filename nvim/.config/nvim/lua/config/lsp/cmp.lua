local M = {}

M._integrate_autopairs = function()
   local cmp_present, cmp = pcall(require, "cmp")
   if not cmp_present then
      require("utils").warn("could not require cmp from lsp keymaps", "cmp-config")
      return
   end

   local cmp_autopairs_present, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
   if not cmp_autopairs_present then
      require("utils").warn("could not require nvim-autopairs.completion.cmp from lsp keymaps", "cmp-config")
      return
   end

   -- configure it with cmp support, e.g. adding () when autocompleting a function
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

M._get_mapping = function()
   local cmp_present, cmp = pcall(require, "cmp")
   if not cmp_present then
      require("utils").warn("could not require nvim-cmp from lsp keymaps", "cmp-config")
      return
   end

   local luansip_present, luasnip = pcall(require, "luasnip")
   if not luansip_present then
      require("utils").warn("could not require luasnip from lsp keymaps", "cmp-config")
      return
   end

   local mapping = {
      -- toggle auto complete
      ["<C-Space>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.close()
         else
            cmp.complete()
         end
      end),

      -- confirm selection; insert
      ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = false },
      -- confirm selection; replace
      -- or go to next snippet placeholder
      ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
         elseif luasnip.jumpable(1) then
            luasnip.jump(1)
         else
            fallback()
         end
      end),

      -- go to previous snippet placeholder
      ["<S-Tab>"] = cmp.mapping(function(fallback)
         if luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end, { 'i', 's' }),
      -- navigate selection
      ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },

      -- scroll docs
      ["<C-n>"] = cmp.mapping.scroll_docs(2),
      ["<C-p>"] = cmp.mapping.scroll_docs(-2),
   }

   return mapping
end

M._get_sources = function()
   local sources = {
      { name = "orgmode" },
      { name = "copilot" },
      { name = 'path' },
      { name = 'nvim_lsp', keyword_length = 3 },
      { name = 'buffer', keyword_length = 3 },
      { name = 'luasnip', keyword_length = 3 },
   }
   return sources
end

M.setup = function()
   local lsp_present, lsp = pcall(require, "lsp-zero")
   if not lsp_present then
      require("utils").warn("could not require lsp-zero from lsp keymaps", "cmp-config")
      return
   end


   lsp.setup_nvim_cmp({ sources = M._get_sources(), mapping = M._get_mapping() })
   M._integrate_autopairs()
end

return M
