local lsp_path = require("lspconfig/util").path

local function is_empty(s)
  return s == nil or s == ""
end

local function get_pipenv_venv_path(workspace)
  workspace = workspace or vim.fn.getcwd()

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(lsp_path.join(workspace, "Pipfile"))
  if not is_empty(match) then
    local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv 2>/dev/null"))
    require("notify")("Found pipenv venv", "debug", { title = "Python" })
    return venv
  end
  return ""
end

local function get_peotry_venv_path(workspace)
  workspace = workspace or vim.fn.getcwd()

  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(lsp_path.join(workspace, "poetry.lock"))
  if not is_empty(match) then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
    require("notify")("Found poetry venv", "debug", { title = "Python" })
    return venv
  end
  return ""
end

local function get_local_venv_path(workspace)
  local path = lsp_path.join(workspace, ".venv")
  if not is_empty(vim.fn.glob(path)) then
    require("notify")("Found local venv", "debug", { title = "Python" })
    return lsp_path.dirname(path)
  end

  return ""
end

local function get_venv_path(workspace)
  workspace = workspace or vim.fn.getcwd()
  local venv = vim.VIRTUAL_ENV
    or get_pipenv_venv_path(workspace)
    or get_peotry_venv_path(workspace)
    or get_local_venv_path(workspace)

  require("notify")("Using  venv: " .. venv, "debug", { title = "Python" })
  return venv
end

return {
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python", "rust", "toml" })
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        -- Order of formatters matters. They are used in order of appearance.
        nls.builtins.diagnostics.mypy.with({
          filetypes = { "python" },
          prefer_local = lsp_path.join(get_venv_path(), "bin"),
        }),
        nls.builtins.formatting.ruff.with({
          filetypes = { "python" },
          prefer_local = lsp_path.join(get_venv_path(), "bin"),
        }),
        nls.builtins.formatting.black.with({
          filetypes = { "python" },
          prefer_local = lsp_path.join(get_venv_path(), "bin"),
        }),
      })
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- if type(opts.ensure_installed) == "table" then
      --   -- instead of installing them here, we use the tools from the virtualenv
      --   -- which rtx puts on the path
      --   vim.list_extend(opts.ensure_installed, { "black",  "mypy" })
      -- end
    end,
  },

  -- correctly setup mason dap extensions
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff_lsp = {
          init_options = {
            settings = {
              --     args = { "--max-line-length=180" },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = lsp_path.join(get_venv_path(), "bin", "python"),
        }),
      })
    end,
  },

  -- {
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     "mfussenegger/nvim-dap-python",
  --     config = function()
  --       require("dap-python").setup() -- Use default python
  --     end,
  --   },
  -- },
}
