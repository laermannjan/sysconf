local M = {}

local Terminal = require("toggleterm.terminal").Terminal


local git_client = Terminal:new {
   cmd = "lazygit",
   hidden = true,
   direction = "float",
   float_opts = {
      border = "double",
   },
}

local docker_client = Terminal:new {
   cmd = "lazydocker",
   hidden = true,
   direction = "float",
   float_opts = {
      border = "double",
   },
}

function M.git_client_toggle()
   git_client:toggle()
end

function M.docker_client_toggle()
   docker_client:toggle()
end

return M
