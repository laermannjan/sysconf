{ ... }:
{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];

    plugins = {
      crates-nvim.enable = true;
      luasnip.enable = true;
      lspkind = {
        cmp = {
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            crates = "[crates]";
          };
        };
      };
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          mapping = {
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' })";
            "<C-b>" = "cmp.mapping.scroll_docs(-2)";
            "<C-f>" = "cmp.mapping.scroll_docs(2)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-h>" = ''
              function()
                  if cmp.visible_docs() then
                      cmp.close_docs()
                  else
                      cmp.open_docs()
                  end
              end
            '';

            "<C-e>" = ''
              cmp.mapping(function(fallback)
                  local _, ok = pcall(require, "copilot.suggestion")
                  if ok and require("copilot.suggestion").is_visible() then
                      require("copilot.suggestion").dismiss()
                  elseif cmp.visible() then
                      cmp.abort()
                      cmp.close()
                  else
                      fallback()
                  end
              end, { "i", "c" })
            '';

            # Accept currently selected item. If none selected, `select` first item.
            # Set `select` to `false` to only confirm explicitly selected items.
            "<CR>" = "cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert }";
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                      local _, ok = pcall(require, "copilot.suggestion")
                      if ok and luasnip.jumpable(-1) then
                          luasnip.jump(-1)
                      elseif require("copilot.suggestion").is_visible() then
                          require("copilot.suggestion").accept_word()
                      else
                          fallback()
                      end
                  end, { "i", "s", })

            '';
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                  local _, copilot_ok = pcall(require, "copilot.suggestion")
                  local _, tabout_ok = pcall(require, "neotab")
                  local check_backspace = function()
                      local col = vim.fn.col "." - 1
                      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
                  end

                  if ok and require("copilot.suggestion").is_visible() then
                      require("copilot.suggestion").accept_word()
                  elseif cmp.visible() then
                      cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }
                  elseif luasnip.expandable() then
                      luasnip.expand()
                  elseif luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                  elseif check_backspace() then
                      -- fallback()
                      require("neotab").tabout()
                  else
                      require("neotab").tabout()
                      -- fallback()
                  end
              end, { "i", "s", })
            '';
          };

          sources = [
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "crates"; }
            { name = "dap"; }
            {
              name = "buffer";
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
        };
      };
    };
  };
}
