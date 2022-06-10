local wk = require("which-key")
local util = require("util")

local M = {}

function M.setup(client, bufnr)
    -- Mappings.
    local opts = { noremap = true, silent = false, buffer = bufnr }

    local keymap = {
        c = {
            name = "+code",
            r = { "<cmd>lua require('lspsaga.rename').rename()<CR>", "Rename" },
            --a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
            a = { "<cmd>lua require('lspsaga.codeaction').code_action()", "Code Action" },
            c = { "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>", "Show Diagnostics under Cursor" },
            -- d = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
            d = { "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", "Show Line Diagnostics" },
            s = { "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", "Signature Help" },
            h = { "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", "Hover Documentation" },
            f = { "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "Find Definitions and References" },
            l = {
                name = "+lsp",
                i = { "<cmd>LspInfo<cr>", "Lsp Info" },
                a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
                r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
                l = {
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    "List Folders",
                },
            },
        },
        x = {
            s = { "<cmd>Telescope document_diagnostics<cr>", "Search Document Diagnostics" },
            w = { "<cmd>Telescope workspace_diagnostics<cr>", "Workspace Diagnostics" },
        },
    }

    if client.name == "typescript" then
        keymap.c.o = { "<cmd>:TSLspOrganize<CR>", "Organize Imports" }
        keymap.c.R = { "<cmd>:TSLspRenameFile<CR>", "Rename File" }
    end

    local keymap_visual = {
        c = {
            name = "+code",
            a = { ":<C-U>lua vim.lsp.buf.range_code_action()<CR>", "Code Action" },
        },
    }

    local keymap_goto = {
        name = "+goto",
        r = { "<cmd>Telescope lsp_references<cr>", "References" },
        R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
        d = { "<cmd>lua require('lspsaga.provider').preview_definition()<CR>", "Preview Definition" },
        dv = { "<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>", "Goto Definition + window-split-right" },
        ds = { "<Cmd>split | lua vim.lsp.buf.definition()<CR>", "Goto Definition + window-split-below" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
        -- I = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
        t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
    }

    -- util.nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    util.nnoremap("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    util.nnoremap("<C-j>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
    util.nnoremap("<C-k>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)
    util.nnoremap("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    util.nnoremap("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    -- util.nnoremap("[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    util.nnoremap("[e", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
    -- util.nnoremap("]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    util.nnoremap("]e", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

    util.nnoremap("<A-d>", "<cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>", opts)
    -- util.tmap("<A-d>", "<C-Bslash><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>", opts)
    vim.cmd([[tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>]])

    local trigger_chars = client.server_capabilities.signatureHelpTriggerCharacters
    trigger_chars = { "," }
    for _, c in ipairs(trigger_chars) do
        util.inoremap(c, function()
            vim.defer_fn(function()
                pcall(vim.lsp.buf.signature_help)
            end, 0)
            return c
        end, {
            noremap = true,
            silent = true,
            buffer = bufnr,
            expr = true,
        })
    end

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormatting then
        keymap.c.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
    elseif client.server_capabilities.documentRangeFormatting then
        keymap_visual.c.f = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format Range" }
    end

    wk.register(keymap, { buffer = bufnr, prefix = "<leader>" })
    wk.register(keymap_visual, { buffer = bufnr, prefix = "<leader>", mode = "v" })
    wk.register(keymap_goto, { buffer = bufnr, prefix = "g" })
end

return M
