local M = {}

local navic = require("nvim-navic")

local config = {
   options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
         statusline = {},
         winbar = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "alpha",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "dap-repl",
            "dapui_console",
            "dapui_watches",
            "dapui_stacks",
            "dapui_breakpoints",
            "dapui_scopes",
         },
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
         statusline = 1000,
         tabline = 1000,
         winbar = 1000,
      }
   },
   sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
         { 'filename' },
         { navic.get_location }

      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
   },
   inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
   },
   tabline = {},
   winbar = {},
   inactive_winbar = {},
   extensions = {}
}

M.setup = function()
   utils = require("utils")
   local status_ok, lualine = pcall(require, "lualine")
   if not status_ok then
      utils.warn("Lualine could not be required.", "lualine-config")
   end

   lualine.setup(config)
end

return M
