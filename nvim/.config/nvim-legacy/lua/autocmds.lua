local api = vim.api

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
   command = "silent! lua vim.highlight.on_yank()",
   group = yankGrp,
})

-- create directories when needed, when saving a file
api.nvim_create_autocmd("BufWritePre", {
   group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
   command = [[call mkdir(expand('<afile>:p:h'), 'p')]],
})

-- windows to close with q
api.nvim_create_autocmd("FileType", {
   pattern = {
      "help",
      "startuptime",
      "qf",
      "lspinfo",
      "vim",
      "OverseerList",
      "OverseerForm",
      "fugitive",
      "toggleterm",
      "floggraph",
      "git",
      "neotest-summary",
      "query",
      "tsplayground",
      "neotest-output",
   },
   command = [[nnoremap <buffer><silent> q :close<CR>]],
})
api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
api.nvim_create_autocmd("FileType", { pattern = "cheat", command = [[nnoremap <buffer><silent> q :quit<CR>]] })


-- Run PackerCompile if there are changes in this file
-- local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--    pattern = "init.lua",
--    callback = function()
--       vim.cmd("source <afile>")
--       vim.cmd("PackerCompile")
--    end,
--    group = packer_grp
-- })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--    pattern = "plugins.lua",
--    callback = function()
--       vim.cmd("source <afile>")
--       vim.cmd("PackerSync")
--       -- vim.cmd("PackerCompile")
--    end,
--    group = packer_grp
-- })
--
