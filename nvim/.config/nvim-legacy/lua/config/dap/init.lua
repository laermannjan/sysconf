local M = {}

local configure_dap = function()
   local dap_breakpoint = {
      error = {
         text = "🟥",
         texthl = "LspDiagnosticsSignError",
         linehl = "",
         numhl = "",
      },
      rejected = {
         text = "",
         texthl = "LspDiagnosticsSignHint",
         linehl = "",
         numhl = "",
      },
      stopped = {
         text = "⭐️",
         texthl = "LspDiagnosticsSignInformation",
         linehl = "DiagnosticUnderlineInfo",
         numhl = "LspDiagnosticsSignInformation",
      },
   }
   vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
   vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
   vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
end


local configure_extensions = function()
   require("nvim-dap-virtual-text").setup {
      commented = true,
   }

   local dap, dapui = require "dap", require "dapui"
   dapui.setup {} -- use default
   dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
   end
   dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
   end
   dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
   end
end

local configure_debuggers = function()
   require("config.dap.lua").setup()
   require("config.dap.python").setup()
   -- require("config.dap.rust").setup()
   -- require("config.dap.typescript").setup()
   -- require("config.dap.kotlin").setup()
end

local configure_mappings = function()
   require("config.dap.mappings").setup()
end

M.setup = function()
   configure_dap()
   configure_extensions()
   configure_debuggers()
   configure_mappings()
end

return M
