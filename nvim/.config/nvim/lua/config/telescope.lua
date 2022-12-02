local M = {}

M.setup = function()
   local ok, telescope = pcall(require, "telescope")
   if not ok then
      require("utils").warn("could not require telescope", "telescope-config")
   end

   telescope.setup {
      pickers = {
         git_files = {
            theme = "ivy"
         },
         find_files = {
            theme = "dropdown"
         },

      },
      extensions = {
         file_browser = {
            theme = "ivy"
         }
      }
   }

   telescope.load_extension "file_browser"
   -- telescope.load_extension "project" -- telescope-project
   telescope.load_extension "projects" -- project.nvim

end
return M
