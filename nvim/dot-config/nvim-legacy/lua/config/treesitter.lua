local M = {}

function M.setup()
   local swap_next, swap_prev = (function()
      local swap_objects = {
         p = "@parameter.inner",
         f = "@function.outer",
         c = "@class.outer",
      }

      local n, p = {}, {}
      for key, obj in pairs(swap_objects) do
         n[string.format("<Leader>cx%s", key)] = obj
         p[string.format("<Leader>cX%s", key)] = obj
      end

      return n, p
   end)()

   require("nvim-treesitter.configs").setup({
      ensure_installed = "all",

      highlight = {
         enable = true
      },

      -- nvim-treesitter-textsubjects
      textsubjects = {
         enable = true,
         prev_selection = ",", -- (Optional) keymap to select the previous selection
         keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
         },
      },


      -- nvim-treesitter-textobjects
      textobjects = {
         select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
               -- You can use the capture groups defined in textobjects.scm
               ["af"] = "@function.outer",
               ["if"] = "@function.inner",
               ["ac"] = "@class.outer",
               ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            selection_modes = {
               ["@parameter.outer"] = "v", -- charwise
               ["@function.outer"] = "V", -- linewise
               ["@class.outer"] = "<c-v>", -- blockwise
            },
         },

         swap = {
            enable = true,
            swap_next = swap_next,
            swap_previous = swap_prev,
            -- swap_next = {
            --   ["<leader>cx"] = "@parameter.inner",
            -- },
            -- swap_previous = {
            --   ["<leader>cX"] = "@parameter.inner",
            -- },
         },

         move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
               ["]m"] = "@function.outer",
               ["]]"] = "@class.outer",
            },
            goto_next_end = {
               ["]M"] = "@function.outer",
               ["]["] = "@class.outer",
            },
            goto_previous_start = {
               ["[m"] = "@function.outer",
               ["[["] = "@class.outer",
            },
            goto_previous_end = {
               ["[M"] = "@function.outer",
               ["[]"] = "@class.outer",
            },
         },
      },

      -- autotag
      autotag = {
         enable = true,
      },

      -- context_commentstring
      context_commentstring = {
         enable = true,
         --enable_autocmd = false,
      },
   })
end

return M
