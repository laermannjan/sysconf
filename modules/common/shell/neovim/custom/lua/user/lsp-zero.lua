return {
	{ "williamboman/mason.nvim" },
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
		ft = "lua", -- only load on lua files
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
            local icons = require "user.icons"

			local lsp_attach = function(client, bufnr)
				local opts = { buffer = bufnr }

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
				vim.keymap.set({ "n", "i" }, "<c-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "gd", ":Trouble lsp_definitions<cr>", opts)
				vim.keymap.set("n", "gD", ":Trouble lsp_declarations<cr>", opts)
				vim.keymap.set("n", "gi", ":Trouble lsp_implementations<cr>", opts)
				vim.keymap.set("n", "go", ":Trouble lsp_type_definitions<cr>", opts)
				vim.keymap.set("n", "gr", ":Trouble lsp_references<cr>", opts)
				vim.keymap.set({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
				vim.keymap.set("n", "<leader>ld", ":Trouble diagnostics toggle filter.buf=0<cr>", opts)
				vim.keymap.set("n", "<leader>ls", ":Trouble symbols toggle<cr>", opts)
				vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>la", require("actions-preview").code_actions, opts)
				vim.keymap.set("n", "<leader>lcc", vim.lsp.codelens.run, { buffer = bufnr, desc = "code lens action" })
				vim.keymap.set(
					"n",
					"<leader>lcr",
					vim.lsp.codelens.refresh,
					{ buffer = bufnr, desc = "refresh & display Codelens" }
				)

				-- highlight symbol under cursor; depends on `vim.opt.updatetime`
				lsp_zero.highlight_symbol(client, bufnr)
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

			require("mason").setup {}
			require("mason-lspconfig").setup {
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup {}
					end,
				},
			}

			local cmp = require "cmp"
			local cmp_action = lsp_zero.cmp_action()
			local luasnip = require "luasnip"

			-- this is the function that loads the extra snippets
			-- from rafamadriz/friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup {
				sources = {
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

					["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
					["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
					["<C-u>"] = cmp.mapping.scroll_docs(-2),
					["<C-d>"] = cmp.mapping.scroll_docs(2),
					["<C-e>"] = cmp.mapping(function(fallback)
						if require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").dismiss()
						elseif cmp.visible() then
							cmp.abort()
							cmp.close()
						else
							fallback()
						end
					end, { "i", "c" }),
					["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
					["<Tab>"] = cmp.mapping(function(fallback)
						local _, ok = pcall(require, "copilot.suggestion")
						if ok and require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept_word()
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
						local _, ok = pcall(require, "copilot.suggestion")
						if ok and luasnip.jumpable(-1) then
							luasnip.jump(-1)
						elseif require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept_word()
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
