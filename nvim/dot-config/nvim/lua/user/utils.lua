local M = {}

function M.get_clients(opts)
	local ret = {} ---@type lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.on_rename(from, to)
	local clients = get_clients()
	for _, client in ipairs(clients) do
		if client.supports_method "workspace/willRenameFiles" then
			---@diagnostic disable-next-line: invisible
			local resp = client.request_sync("workspace/willRenameFiles", {
				files = {
					{
						oldUri = vim.uri_from_fname(from),
						newUri = vim.uri_from_fname(to),
					},
				},
			}, 1000, 0)
			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end
end

function M.create_autoformat_autocmd(client, bufnr)
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
end

return M
