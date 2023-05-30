local M = {}

M.LSP_status = function()
    if rawget(vim, "lsp") then
        local client_names = {}

        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

        -- attached LSP servers
        for _, client in ipairs(vim.lsp.get_active_clients()) do
            if client.attached_buffers[bufnr] and client.name ~= "null-ls" then
                table.insert(client_names, client.name)
            end
        end

        -- add null-ls
        local sources = require("null-ls.sources")
        for _, source in ipairs(sources.get_available(filetype)) do
            for method, enabled in pairs(source.methods) do
                if (method == "NULL_LS_FORMATTING" or method == "NULL_LS_DIAGNOSTICS") and enabled then
                    table.insert(client_names, source.name)
                end
            end
        end

        local names = table.concat(client_names, ", ")
        local names_str = (names ~= "" and "[" .. names .. "]") or "No Active Lsp"

        return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. names_str .. " ") or "   LSP "
    end
end

return {
    "nvim-lualine/lualine.nvim",
    opts = {
        sections = {
            lualine_x = {
                {
                    M.LSP_status or "",
                    -- icon = "WWW",
                    color = { gui = "bold" },
                    on_click = function()
                        vim.cmd([[LspInfo]])
                    end,
                },
            },
        },
    },
}
