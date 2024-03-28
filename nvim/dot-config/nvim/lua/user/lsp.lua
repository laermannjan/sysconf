local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"williamboman/mason.nvim",
		"nvim-lua/plenary.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"folke/neodev.nvim",
	},
}

local function add_lsp_keymaps(bufnr)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "declaration" })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "definiton" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "hover" })
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "signature help" })
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "implementation" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "references" })
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "open diagnostic float" })
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename symbol" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action" })
	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "code lens action" })
	vim.keymap.set("n", "<leader>uh", M.toggle_inlay_hints, { buffer = bufnr, desc = "toggle inlay hints" })
end

M.on_attach = function(client, bufnr)
	add_lsp_keymaps(bufnr)
	require("user.utils").create_autoformat_autocmd(client, bufnr)

	if client.supports_method "textDocument/inlayHint" then
		vim.lsp.inlay_hint.enable(bufnr, true)
	end

	if client.name == "ruff_lsp" then
		-- Disable hover in favor of Pyright
		client.server_capabilities.hoverProvider = false
	end
end

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	-- lsp based folds, important for nvim-ufo
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	return capabilities
end

M.servers = {
	"lua_ls",
	"cssls",
	"html",
	"astro",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"marksman",
	"tailwindcss",
	"eslint",
	"rust_analyzer",
	"gopls",
	"ruff_lsp",
}

function M.config()
	require("mason").setup {
		ui = {
			border = "rounded",
		},
	}
	require("mason-lspconfig").setup { ensure_installed = M.servers }

	local lspconfig = require "lspconfig"
	local icons = require "user.icons"

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	require("lspconfig.ui.windows").default_options.border = "rounded"

	for _, server in pairs(M.servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
		}

		local require_ok, settings = pcall(require, "user.lspsettings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		if server == "lua_ls" then
			require("neodev").setup {}
		end

		lspconfig[server].setup(opts)
	end
end

return M
