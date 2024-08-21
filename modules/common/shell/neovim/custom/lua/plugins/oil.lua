local detail = false
return {
   "stevearc/oil.nvim",
   keys = { { "-", "<Cmd>Oil <CR>", { desc = "open parent directory in oil" } } },
   opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
      default_file_explorer = true,
      keymaps = {
         ["<C-h>"] = false,
         ["<C-l>"] = false,
         ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
               detail = not detail
               if detail then
                  require("oil").set_columns { "icon", "permissions", "size", "mtime" }
               else
                  require("oil").set_columns { "icon" }
               end
            end,
         },
      },
   },
   -- Optional dependencies
   dependencies = { { "echasnovski/mini.icons", opts = {} } },
   -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
