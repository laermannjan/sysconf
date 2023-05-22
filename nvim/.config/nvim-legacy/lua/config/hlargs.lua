local M = {}

M.setup = function()
   require('hlargs').setup {
      color = '#09bc8a',
      hl_priority = 150,
      -- highlight = {
      --    fg = '#09',
      --    italic = true,
      --    cterm = { italic = true }
      -- },

      excluded_filetypes = {},
      paint_arg_declarations = true,
      paint_arg_usages = true,
      paint_catch_blocks = {
         declarations = false,
         usages = false
      },
      extras = {
         named_parameters = false,
      },
      excluded_argnames = {
         declarations = {
            python = { 'self', 'cls' },
         },
         usages = {
            python = { 'self', 'cls' },
            lua = { 'self' }
         }
      },
      performance = {
         parse_delay = 1,
         slow_parse_delay = 50,
         max_iterations = 400,
         max_concurrent_partial_parses = 30,
         debounce = {
            partial_parse = 3,
            partial_insert_mode = 100,
            total_parse = 700,
            slow_parse = 5000
         }
      }
   }
end

return M
