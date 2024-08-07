return {
   "rebelot/heirline.nvim",
   opts = function(_, opts)
      local status = require "astroui.status"

      status.component.grapple = {
         provider = function()
            local available, grapple = pcall(require, "grapple")
            if available then
               return grapple.statusline()
            end
         end,
      }

      table.insert(opts.statusline, 3, status.component.grapple)
   end,
}
