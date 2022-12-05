local M = {}

M.setup = function()
   local tz = require("true-zen")
   vim.keymap.set("n", "<leader>zzn", "<cmd>TZNarrow<CR>", { desc = "Narrow" })
   vim.keymap.set("n", "<leader>zzf", "<cmd>TZFocus<CR>", { desc = "Focus" })
   vim.keymap.set("n", "<leader>zza", "<cmd>TZAtaraxis<CR>", { desc = "Ataraxis" })
   vim.keymap.set("n", "<leader>zzm", "<cmd>TZMinimalist<CR>", { desc = "Minimal" })
   tz.setup()
end

return M
