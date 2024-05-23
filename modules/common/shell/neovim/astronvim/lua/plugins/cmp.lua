return { -- override nvim-cmp plugin
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end

    opts.mapping = {
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
      ["<Tab>"] = cmp.mapping(function(fallback)
        local copilot, copilot_ok = pcall(require, "copilot.suggestion")
        local neotab, neotab_ok = pcall(require, "neotab")
        if copilot_ok and copilot.is_visible() then
          copilot.accept_word()
        elseif cmp.visible() then
          cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif neotab_ok then
          neotab.tabout()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        local copilot, copilot_ok = pcall(require, "copilot.suggestion")
        if copilot_ok and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif copilot_ok and copilot.is_visible() then
          copilot.accept_word()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }
  end,
}
