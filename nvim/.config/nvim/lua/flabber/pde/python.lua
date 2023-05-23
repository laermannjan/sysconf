if not vim.g.flabber.pde.python then
    return {}
end

-- Vim test
vim.g["test#python#runner"] = "pytest"

local path = require("lspconfig/util").path

local is_empty = function(s)
    return s == nil or s == ""
end

local get_pipenv_venv_path = function(workspace)
    workspace = workspace or vim.fn.getcwd()

    -- Find and use virtualenv from pipenv in workspace directory.
    local match = vim.fn.glob(path.join(workspace, "Pipfile"))
    if not is_empty(match) then
        local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
        return venv
    end
    return ""
end

local get_peotry_venv_path = function(workspace)
    workspace = workspace or vim.fn.getcwd()

    -- Find and use virtualenv via poetry in workspace directory.
    local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
    if not is_empty(match) then
        local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
        return venv
    end
    return ""
end

local get_local_python_path = function(workspace)
    workspace = workspace or vim.fn.getcwd()

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({ "*", ".*" }) do
        local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
        if not is_empty(match) then
            return path.dirname(match)
        end
    end
    return ""
end

local get_virtual_env_path = function(workspace)
    workspace = workspace or vim.fn.getcwd()

    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV
    end

    local pipenv_path = get_pipenv_venv_path(workspace)
    if not is_empty(pipenv_path) then
        return pipenv_path
    end

    local poetry_path = get_peotry_venv_path(workspace)
    if not is_empty(poetry_path) then
        return poetry_path
    end

    local local_path = path.join(workspace, ".venv")
    if not is_empty(vim.fn.glob(local_path)) then
        return path.dirname(local_path)
    end

    return ""
end

local get_python_bin_path = function(args)
    local workspace = args.workspace or vim.fn.getcwd()
    local bin = args.bin or "python"

    local venv_path = get_virtual_env_path(workspace)
    if not is_empty(venv_path) then
        local bin_path = vim.fn.glob(path.join(venv_path, "bin", bin))
        if not is_empty(bin_path) then
            return bin_path
        end
    end

    -- Fallback to system Python.
    local bin_path = vim.fn.exepath(bin)
    return bin_path
end

return {
    {
        "nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "python", "toml", "yaml" })
        end,
    },
    {
        "mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "pyright", "ruff_lsp" })
        end,
    },
    {
        "nvim-lspconfig",
        config = function(_, opts)
            require("lspconfig").pyright.setup({
                single_file_support = true,
                settings = {
                    pyright = {
                        disableLanguageServices = false,
                        disableOrganizeImports = false,
                    },
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "workspace", -- openFilesOnly, workspace
                            typeCheckingMode = "basic", -- off, basic, strict
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })
        end,
    },
    {
        "null-ls.nvim",
        opts = function(_, opts)
            local null_ls = require("null-ls")
            vim.list_extend(opts.sources, {
                null_ls.builtins.formatting.black.with({
                    command = get_python_bin_path({ bin = "black" }),
                }),
            })
            vim.list_extend(opts.sources, {
                null_ls.builtins.diagnostics.mypy.with({
                    command = get_python_bin_path({ bin = "mypy" }),
                }),
            })
        end,
    },

    {
        "neotest",
        dependencies = { "nvim-neotest/neotest-python" },
        opts = function(_, opts)
            vim.list_extend(opts.adapters, require("neotest-python"))
        end,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            config = function()
                require("dap-python").setup() -- Use default python
            end,
        },
    },
}
