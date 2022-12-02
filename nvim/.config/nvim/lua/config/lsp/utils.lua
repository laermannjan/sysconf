local path = require('lspconfig/util').path
local is_empty = require("utils").is_empty

local M = {}

M.get_pipenv_venv_path = function(workspace)
   workspace = workspace or vim.fn.getcwd()

   -- Find and use virtualenv from pipenv in workspace directory.
   local match = vim.fn.glob(path.join(workspace, 'Pipfile'))
   if not is_empty(match) then
      local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
      return venv
   end
   return ''
end

M.get_peotry_venv_path = function(workspace)
   workspace = workspace or vim.fn.getcwd()

   -- Find and use virtualenv via poetry in workspace directory.
   local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
   if not is_empty(match) then
      local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
      return venv
   end
   return ''
end

M.get_local_python_path = function(workspace)
   workspace = workspace or vim.fn.getcwd()

   -- Find and use virtualenv in workspace directory.
   for _, pattern in ipairs({ '*', '.*' }) do
      local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
      if not is_empty(match) then
         return path.dirname(match)
      end
   end
   return ''
end

M.get_virtual_env_path = function(workspace)
   workspace = workspace or vim.fn.getcwd()

   -- Use activated virtualenv.
   if vim.env.VIRTUAL_ENV then
      require("utils").debug("found active virtual env: " .. vim.env.VIRTUAL_ENV, "python_venv")
      return vim.env.VIRTUAL_ENV
   end

   local pipenv_path = M.get_pipenv_venv_path(workspace)
   if not is_empty(pipenv_path) then
      require("utils").debug("found pipenv virtual env: " .. pipenv_path, "python_venv")
      return pipenv_path
   end

   local poetry_path = M.get_peotry_venv_path(workspace)
   if not is_empty(poetry_path) then
      require("utils").debug("found poetry virtual env: " .. poetry_path, "python_venv")
      return poetry_path
   end

   local local_path = path.join(workspace, ".venv")
   if not is_empty(vim.fn.glob(local_path)) then
      require("utils").debug("found local virtual env: " .. local_path, "python_venv")
      return path.dirname(local_path)
   end

   return ''
end




M.get_python_bin_path = function(args)
   local workspace = args.workspace or vim.fn.getcwd()
   local bin = args.bin or 'python'

   local venv_path = M.get_virtual_env_path(workspace)
   if not is_empty(venv_path) then
      local bin_path = vim.fn.glob(path.join(venv_path, "bin", bin))
      if not is_empty(bin_path) then
         require("utils").debug("found " .. bin .. " @ " .. bin_path, "python_venv")
         return bin_path
      end
   end

   -- Fallback to system Python.
   local bin_path = vim.fn.exepath(bin)
   require("utils").debug("using fallback " .. bin .. " @ " .. bin_path, "python_venv")
   return bin_path
end



return M
