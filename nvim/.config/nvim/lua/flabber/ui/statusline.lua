local M = {}

M.LSP_progress = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    local Lsp = vim.lsp.util.get_progress_messages()[1]

    if vim.o.columns < 120 or not Lsp then
        return ""
    end

    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0
    local title = Lsp.title or ""
    local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

    -- if config.lsprogress_len then
    --     content = string.sub(content, 1, config.lsprogress_len)
    -- end

    return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    errors = (errors and errors > 0) and ("%#St_lspError#" .. " " .. errors .. " ") or ""
    warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. "  " .. warnings .. " ") or ""
    hints = (hints and hints > 0) and ("%#St_lspHints#" .. "󰛩 " .. hints .. " ") or ""
    info = (info and info > 0) and ("%#St_lspInfo#" .. "󰋼 " .. info .. " ") or ""

    return errors .. warnings .. hints .. info
end

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
    "nvimlualine/lualine.nvim",
    opts = {
        sections = {
            lualine_x = {
                M.LSP_status or "",
                M.LSP_progress or "",
                -- M.LSP_Diagnostics or "",
            },
        },
    },
}
