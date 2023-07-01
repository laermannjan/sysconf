local M = {}

M.setup = function()
   require("dap-python").setup("python", {})
   table.insert(require("dap").configurations.python, {
      type = "python",
      request = "attach",
      connect = {
         host = "127.0.0.1",
         port = 5678,
      },
      mode = "remote",
      name = "Container Attach Debug",
      cwd = vim.fn.getcwd(),
      pathMappings = {
         {
            localRoot = function()
               return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
            end,
            remoteRoot = function()
               return vim.fn.input("Container code folder > ", "/", "file")
            end
         }
      }
   })
end

return M
