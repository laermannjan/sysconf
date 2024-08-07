return {
   "mrjones2014/smart-splits.nvim",
   dependencies = {
      {
         "AstroNvim/astrocore",
         opts = function(_, opts)
            local maps = opts.mappings
            maps.n["<C-H>"] = {
               function()
                  require("smart-splits").move_cursor_left()
               end,
               desc = "Move to left split",
            }
            maps.n["<C-J>"] = {
               function()
                  require("smart-splits").move_cursor_down()
               end,
               desc = "Move to below split",
            }
            maps.n["<C-K>"] = {
               function()
                  require("smart-splits").move_cursor_up()
               end,
               desc = "Move to above split",
            }
            maps.n["<C-L>"] = {
               function()
                  require("smart-splits").move_cursor_right()
               end,
               desc = "Move to right split",
            }
            maps.n["<C-Up>"] = false
            maps.n["<C-Down>"] = false
            maps.n["<C-Left>"] = false
            maps.n["<C-Right>"] = false
            maps.n["<C-S-H>"] = {
               function()
                  require("smart-splits").resize_left()
               end,
               desc = "Resize split left",
            }
            maps.n["<C-S-J>"] = {
               function()
                  require("smart-splits").resize_down()
               end,
               desc = "Resize split down",
            }
            maps.n["<C-S-K>"] = {
               function()
                  require("smart-splits").resize_up()
               end,
               desc = "Resize split up",
            }
            maps.n["<C-S-L>"] = {
               function()
                  require("smart-splits").resize_right()
               end,
               desc = "Resize split right",
            }
         end,
      },
   },
}
