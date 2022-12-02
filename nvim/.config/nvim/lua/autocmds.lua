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
