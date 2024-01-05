local M = {
	"nvimtools/none-ls.nvim",
	dependencies = { "jay-babu/mason-null-ls.nvim", "williamboman/mason.nvim" },
}

function M.config()
	local null_ls = require "null-ls"

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup {
		debug = false,
		on_attach = function(client, bufnr)
			if client.supports_method "textDocument/formatting" then
				vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format { async = false }
					end,
				})
			end
		end,

		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettier,

			null_ls.builtins.code_actions.gomodifytags,
			null_ls.builtins.code_actions.impl,
			null_ls.builtins.formatting.goimports,
			null_ls.builtins.formatting.gofumpt,

			-- formatting.prettier.with {
			--   extra_filetypes = { "toml" },
			--   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
			-- },
			-- formatting.eslint,
			-- null_ls.builtins.diagnostics.eslint,
			null_ls.builtins.completion.spell,
		},
	}

	require("mason-null-ls").setup {
		---@diagnostic disable: assign-type-mismatch
		ensure_installed = nil,
		automatic_installation = true,
	}
end

return M
