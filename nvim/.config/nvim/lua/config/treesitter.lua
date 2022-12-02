local M = {}

function M.setup()
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
   })
end

return M
