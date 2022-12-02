local M = {}

local ok, whichkey = pcall(require, "which-key")
if not ok then
   require("utils").error("could not require which-key.\nleader mappings will not work", "which-key setup")
   return
end

local conf = {
   window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
   },
}
whichkey.setup(conf)

local opts = {
   mode = "n", -- Normal mode
   prefix = "<leader>",
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true, -- use `silent` when creating keymaps
   noremap = true, -- use `noremap` when creating keymaps
   nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
   mode = "v", -- Visual mode
   prefix = "<leader>",
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true, -- use `silent` when creating keymaps
   noremap = true, -- use `noremap` when creating keymaps
   nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
   local keymap = {
      ["w"] = { "<cmd>w!<CR>", "Save" },
      ["q"] = { "<cmd>lua require('utils').quit()<CR>", "Quit" },

      d = {
         name = "Debug",
      },

      x = {
         name = "Trouble",
         x = { "<cmd>TroubleToggle<cr>", "default" },
         w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics" },
         d = { "<cmd>TroubleToggle<cr> document_diagnostics", "document diagnostics" },
         l = { "<cmd>TroubleToggle loclist<cr>", "open loclist" },
         q = { "<cmd>TroubleToggle lsp_references<cr>", "open lsp reference" },

      },
      c = {
         name = "Code",
         a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
         s = { "<cmd>SidebarNvimToggle<CR>", "sidebar" },
      },

      f = {
         z = { "<cmd>lua require('telescope').extensions.zoxide.list()<CR>", "zoxide" }
      },

      z = {
         name = "System",
         p = { "<cmd>PackerProfile<cr>", "packer profile" },
         s = { "<cmd>PackerSync<cr>", "packer sync" },
         S = { "<cmd>PackerStatus<cr>", "packer status" },
         u = { "<cmd>PackerUpdate<cr>", "packer update" },
      }
   }

   whichkey.register(keymap, opts)
end

M.setup = function()
   normal_keymap()
end

return M
