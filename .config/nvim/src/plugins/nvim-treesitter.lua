local add = MiniDeps.add

add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    depends = {{
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'master',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    }},
})

local ensure_installed = {
            'bash', 'c', 'cpp', 'css', 'go', 'html', 'javascript', 'json', 'julia', 'lua', 'markdown', 'markdown_inline',
            'nix', 'python', 'regex', 'rst', 'rust', 'toml', 'tsx', 'typescript', 'yaml', 'vim', 'vimdoc',
      }

require('nvim-treesitter.configs').setup({
    auto_install = true,
    sync_install = false,
    ensure_installed = ensure_installed,
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            node_decremental = "<c-h>",  -- NOTE: <c-h> same as <c-backspace> in temrinal
        },
    },
    textobjects = { enable = false },
    indent = { enable = true },
})

-- Disable injections in 'lua' language. In Neovim<0.9 it is
-- `vim.treesitter.query.set_query()`; in Neovim>=0.9 it is
-- `vim.treesitter.query.set()`.
-- local ts_query = require('vim.treesitter.query')
-- local ts_query_set = ts_query.set or ts_query.set_query
-- ts_query_set('lua', 'injections', '')
