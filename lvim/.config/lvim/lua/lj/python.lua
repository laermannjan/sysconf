-- Set a formatter.
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { command = "black", filetypes = { "python" } },
    { command = "isort", filetypes = { "python" } },
}

-- Set a linter.
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { command = "flake8", filetypes = { "python" } },
    { command = "mypy", filetypes = { "python" } },
}

-- TODO: debugpy installed by default
-- Setup dap for python
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function() require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python") end)

-- Supported test frameworks are unittest, pytest and django. By default it
-- tries to detect the runner by probing for pytest.ini and manage.py, if
-- neither are present it defaults to unittest.
pcall(function() require("dap-python").test_runner = "pytest" end)

-- Magma Setup

-- Image options. Other options:
-- 1. none:     Don't show images.
-- 2. ueberzug: use Ueberzug to display images.
-- 3. kitty:    use the Kitty protocol to display images.
vim.g.magma_image_provider = "kitty"

-- If this is set to true, then whenever you have an active cell its output
-- window will be automatically shown.
vim.g.magma_automatically_open_output = true

-- If this is true, then text output in the output window will be wrapped.
vim.g.magma_wrap_output = false

-- If this is true, then the output window will have rounded borders.
vim.g.magma_output_window_borders = false

-- The highlight group to be used for highlighting cells.
vim.g.magma_cell_highlight_group = "CursorLine"

-- Where to save/load with :MagmaSave and :MagmaLoad.
-- The generated file is placed in this directory, with the filename itself
-- being the buffer's name, with % replaced by %% and / replaced by %, and
-- postfixed with the extension .json.
vim.g.magma_save_path = vim.fn.stdpath "data" .. "/magma"

-- Mappings

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "python" },
    callback = function()
        lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
        lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
        lvim.builtin.which_key.vmappings["d"] = {
            name = "Debug",
            s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
        }

        lvim.builtin.which_key.mappings["c"] = {
            name = "Code",
            j = { name = "Jupyter",
                i = { "<Cmd>MagmaInit<CR>", "Init Magma" },
                d = { "<Cmd>MagmaDeinit<CR>", "Deinit Magma" },
                e = { "<Cmd>MagmaEvaluateLine<CR>", "Evaluate Line" },
                r = { "<Cmd>MagmaReevaluateCell<CR>", "Re evaluate cell" },
                D = { "<Cmd>MagmaDelete<CR>", "Delete cell" },
                s = { "<Cmd>MagmaShowOutput<CR>", "Show Output" },
                R = { "<Cmd>MagmaRestart!<CR>", "Restart Magma" },
                S = { "<Cmd>MagmaSave<CR>", "Save" },
            }
        }

        lvim.builtin.which_key.vmappings["c"] = {
            name = "Code",
            j = {
                name = "Jupyter",
                e = { "<esc><cmd>MagmaEvaluateVisual<cr>", "Evaluate Highlighted Line" },
            }
        }
    end
})

lvim.builtin.which_key.vmappings["lj"] = {
    name = "Jupyter",
    e = { "<esc><cmd>MagmaEvaluateVisual<cr>", "Evaluate Highlighted Line" },
}

table.insert(lvim.plugins, "mfussenegger/nvim-dap-python")
table.insert(lvim.plugins, {
    -- You can generate docstrings automatically.
    "danymat/neogen",
    config = function()
        require("neogen").setup {
            enabled = true,
            languages = {
                python = {
                    template = {
                        annotation_convention = "numpydoc",
                    },
                },
            },
        }
    end,
})
table.insert(lvim.plugins, { "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" })
