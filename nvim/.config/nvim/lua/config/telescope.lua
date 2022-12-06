local M = {}

M.setup = function()
   local ok, telescope = pcall(require, "telescope")
   if not ok then
      require("utils").warn("could not require telescope", "telescope-config")
      return
   end

   local lga_actions = require("telescope-live-grep-args.actions")

   telescope.setup {
      pickers = {
         git_files = {
            theme = "ivy"
         },
         find_files = {
            theme = "ivy"
         },
         live_grep = {
            theme = "ivy"
         },
         current_buffer_fuzzy_find = {
            theme = "ivy"
         }

      },
      extensions = {
         file_browser = {
            theme = "ivy"
         },
         live_grep_args = {
            theme = "ivy",
            auto_quote = true,
            mappings = {
               i = {
                  ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden" })
               }
            }
         },
      }
   }

   telescope.load_extension "file_browser"
   -- telescope.load_extension "project" -- telescope-project
   telescope.load_extension "projects" -- project.nvim
   telescope.load_extension "aerial"
   telescope.load_extension "dap"

   require('neoclip').setup() -- must be here, see: https://github.com/AckslD/nvim-neoclip.lua/issues/5
   telescope.load_extension "neoclip"
end
return M
