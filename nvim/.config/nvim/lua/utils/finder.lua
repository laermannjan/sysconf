local M = {}

-- Find a file either using git files or search the filesystem.
M.find_files = function(opts)
   local opts = opts or {}
   local telescope = require "telescope.builtin"

   local ok = pcall(telescope.git_files, opts)
   if not ok then
      telescope.find_files(opts)
   end
end

return M
