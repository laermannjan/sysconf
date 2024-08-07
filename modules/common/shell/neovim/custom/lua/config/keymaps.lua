vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<ESC>", "<cmd>noh<cr><ESC>", { silent = true })
vim.keymap.set("n", "n", "nzzzv") -- center next search result
vim.keymap.set("n", "N", "Nzzzv") -- center prev search result
vim.keymap.set("n", "*", "*zzzv") -- center next search result
vim.keymap.set("n", "#", "#zzzv") -- center prev search result
vim.keymap.set("n", "g*", "g*zzzv") -- center next search result
vim.keymap.set("n", "g#", "g#zzzv") -- center prev search result

vim.keymap.set({ "n", "o", "x" }, "<s-h>", "^") -- goto start of line
vim.keymap.set({ "n", "o", "x" }, "<s-l>", "g_") -- goto end of line

-- indent and be able to indent again
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Add undo break-points
vim.keymap.set("i", ",", "<c-g>u,")
vim.keymap.set("i", ".", "<c-g>u.")
vim.keymap.set("i", ";", "<c-g>u;")

vim.keymap.set("v", "p", '"_dP') -- paste over without copy

-- Diagnostic keymaps
local function diagnostic_goto(dir, severity)
    local go = vim.diagnostic["goto_" .. dir]
    if type(severity) == "string" then
        severity = vim.diagnostic.severity[severity]
    end
    return function()
        go({ severity = severity })
    end
end
vim.keymap.set("n", "[d", diagnostic_goto("prev"), { desc = "previous diagnostic" })
vim.keymap.set("n", "]d", diagnostic_goto("next"), { desc = "next diagnostic" })
vim.keymap.set("n", "[w", diagnostic_goto("prev", "WARN"), { desc = "previous warning" })
vim.keymap.set("n", "]w", diagnostic_goto("next", "WARN"), { desc = "next warning" })
vim.keymap.set("n", "[e", diagnostic_goto("prev", "ERROR"), { desc = "previous error" })
vim.keymap.set("n", "]e", diagnostic_goto("next", "ERROR"), { desc = "next error" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "hover diagnostic" })
vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

vim.keymap.set({ "n", "x" }, "j", "gj")
vim.keymap.set({ "n", "x" }, "k", "gk")
vim.keymap.set("n", "<leader>uw", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", { desc = "toggle line wrap" })

vim.keymap.set("t", "<C-;>", "<C-\\><C-n>")

-- Better window navigation  -- NOTE: now using smart-splits.nvim instead
--
-- vim.keymap.set("n", "<m-h>", "<C-w>h", { noremap = true, silent = true })
-- vim.keymap.set("n", "<m-j>", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set("n", "<m-k>", "<C-w>k", { noremap = true, silent = true })
-- vim.keymap.set("n", "<m-l>", "<C-w>l", { noremap = true, silent = true })
--
vim.cmd("cabbrev Wqa wqa")
vim.cmd("cabbrev Wq wq")
vim.cmd("cabbrev Wa wa")
vim.cmd("cabbrev Q q")
