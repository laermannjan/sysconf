return {
   {
      "williamboman/mason.nvim",
      keys = {
         {
            "<leader>pm",
            function()
               require("mason.ui").open()
            end,
            desc = "Mason Installer",
         },
      },
   },
   { "williamboman/mason-lspconfig.nvim" },
   { "neovim/nvim-lspconfig" },
   { "L3MON4D3/LuaSnip" },
   { "hrsh7th/nvim-cmp" },
   { "hrsh7th/cmp-nvim-lsp" },
   { "hrsh7th/cmp-buffer" },
   { "hrsh7th/cmp-path" },
   { "saadparwaiz1/cmp_luasnip" },
   { "rafamadriz/friendly-snippets" },
   { "folke/trouble.nvim", opts = { auto_jump = true, focus = true } },
   { "aznhe21/actions-preview.nvim" },
   { "j-hui/fidget.nvim", opts = {} },
   { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
   {
      "folke/lazydev.nvim",
      -- ft = "lua", -- only load on lua files
      opts = {
         library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
         },
      },
   },
   {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v4.x",

      config = function()
         local lsp_zero = require "lsp-zero"
         local icons = require "config.icons"

         local lsp_attach = function(client, bufnr)
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
            vim.keymap.set({ "n", "i" }, "<c-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "gd", ":Trouble lsp_definitions<cr>", opts)
            vim.keymap.set("n", "gD", ":Trouble lsp_declarations<cr>", opts)
            vim.keymap.set("n", "gi", ":Trouble lsp_implementations<cr>", opts)
            vim.keymap.set("n", "go", ":Trouble lsp_type_definitions<cr>", opts)
            vim.keymap.set("n", "gR", ":Trouble lsp_references<cr>", opts)
            vim.keymap.set({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
            vim.keymap.set("n", "<leader>ld", ":Trouble diagnostics toggle filter.buf=0<cr>", opts)
            vim.keymap.set("n", "<leader>ls", ":Trouble symbols toggle<cr>", opts)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>la", require("actions-preview").code_actions, opts)
            vim.keymap.set("n", "<leader>lcc", vim.lsp.codelens.run, { buffer = bufnr, desc = "code lens action" })
            vim.keymap.set("n", "<leader>lcr", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "refresh & display Codelens" })

            -- highlight symbol under cursor; depends on `vim.opt.updatetime`
            lsp_zero.highlight_symbol(client, bufnr)

            -- format on save
            -- formats using all attached LSPs (including null-ls) in random order
            -- don't forget to disable formatting on certain LSPs (like lua_ls if using stylua)
            lsp_zero.buffer_autoformat()
         end

         lsp_zero.extend_lspconfig {
            lsp_attach = lsp_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
         }

         lsp_zero.ui {
            float_border = "rounded",
            sign_text = {
               error = icons.diagnostics.BoldError,
               warn = icons.diagnostics.BoldWarning,
               hint = icons.diagnostics.BoldHint,
               info = icons.diagnostics.BoldInformation,
            },
         }

         local function disable_lsp()
            return function(server_name)
               vim.notify("disabling " .. server_name, vim.log.levels.DEBUG)
            end
         end

         require("mason").setup {}
         require("mason-lspconfig").setup {
            ensure_installed = {
               "lua_ls",
               "pyright",
               "ruff",
               "gopls",
               "rust_analyzer",
               "marksman",
               "bashls",
               "yamlls",
               "jsonls",
               "html",
            },
            handlers = {
               -- The first entry (without a key) will be the default handler
               -- and will be called for each installed server that doesn't have
               -- a dedicated handler.
               function(server_name) -- default handler
                  local ok, opts = pcall(require, "config.lsp-settings." .. server_name)
                  if ok then
                     vim.notify("applying lsp settings for " .. server_name, vim.log.levels.DEBUG)
                  else
                     opts = {}
                  end
                  require("lspconfig")[server_name].setup(opts)
               end,
               basedpyright = disable_lsp(),
            },
         }

         local cmp = require "cmp"
         local luasnip = require "luasnip"

         -- this is the function that loads the extra snippets
         -- from rafamadriz/friendly-snippets
         require("luasnip.loaders.from_vscode").lazy_load()

         cmp.setup {
            sources = {
               { name = "copilot", priority = 10000 },
               { name = "path" },
               { name = "nvim_lsp" },
               { name = "lazydev" },
               { name = "luasnip", keyword_length = 2 },
               { name = "buffer", keyword_length = 3 },
            },
            window = {
               completion = cmp.config.window.bordered(),
               documentation = cmp.config.window.bordered(),
            },
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            mapping = cmp.mapping.preset.insert {

               ["<C-p>"] = cmp.mapping(function(fallback)
                  local ok, copilot = pcall(require, "copilot.suggestion")
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif ok and copilot.is_visible() then
                     copilot.prev()
                  else
                     fallback()
                  end
               end, { "i", "c" }),
               ["<C-n>"] = cmp.mapping(function(fallback)
                  local ok, copilot = pcall(require, "copilot.suggestion")
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif ok and copilot.is_visible() then
                     copilot.next()
                  else
                     fallback()
                  end
               end, { "i", "c" }),
               ["<C-u>"] = cmp.mapping.scroll_docs(-2),
               ["<C-d>"] = cmp.mapping.scroll_docs(2),
               ["<C-e>"] = cmp.mapping(function(fallback)
                  local ok, copilot = pcall(require, "copilot.suggestion")
                  if cmp.visible() then
                     cmp.abort()
                     cmp.close()
                  elseif ok and copilot.is_visible() then
                     copilot.dismiss()
                  else
                     fallback()
                  end
               end, { "i", "c" }),
               ["<S-CR>"] = cmp.mapping(function(fallback)
                  local ok, copilot = pcall(require, "copilot.suggestion")
                  if ok and copilot.is_visible() then
                     copilot.accept()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
               ["<Tab>"] = cmp.mapping(function(fallback)
                  local ok, copilot = pcall(require, "copilot.suggestion")
                  if ok and copilot.is_visible() then
                     copilot.accept_line()
                  elseif cmp.visible() then
                     cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }
                  elseif luasnip.expandable() then
                     luasnip.expand()
                  elseif luasnip.expand_or_jumpable() then
                     luasnip.expand_or_jump()
                  else
                     require("neotab").tabout()
                  end
               end, {
                  "i",
                  "s",
               }),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, {
                  "i",
                  "s",
               }),
            },
            -- note: if you are going to use lsp-kind (another plugin)
            -- replace the line below with the function from lsp-kind
            formatting = lsp_zero.cmp_format { details = true },
         }
      end,
   },
}
