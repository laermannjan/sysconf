-- local M = {
--    "nvim-tree/nvim-web-devicons",
--    event = "VeryLazy",
-- }
-- function M.config()
--    local devicons = require "nvim-web-devicons"
--
--    devicons.set_icon {
--       astro = {
--          --  󱓟 
--          icon = "󱓞",
--          color = "#FF7E33",
--          name = "astro",
--       },
--       lockb = {
--          --  󱓟 
--          icon = "󰳮",
--          color = "#fbf0df",
--          name = "astro",
--       },
--    }
--
-- end
--
-- return M

return {
   "echasnovski/mini.icons",
   opts = {},
   lazy = true,
   specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
   },
   init = function()
      package.preload["nvim-web-devicons"] = function()
         require("mini.icons").mock_nvim_web_devicons()
         return package.loaded["nvim-web-devicons"]
      end
   end,
}
