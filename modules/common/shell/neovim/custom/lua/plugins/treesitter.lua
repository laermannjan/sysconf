return {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    -- event = { 'VeryLazy' },
    -- lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    -- lazy = false,
    -- init = function(plugin)
    --     -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    --     -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    --     -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    --     -- Luckily, the only things that those plugins need are the custom queries, which we make available
    --     -- during startup.
    --     require('lazy.core.loader').add_to_rtp(plugin)
    --     require('nvim-treesitter.query_predicates')
    -- end,
    -- cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
        auto_install = true,
        sync_install = false,
        ensure_installed = {
            'bash',
            'c',
            'cpp',
            'css',
            'go',
            'html',
            'javascript',
            'json',
            'julia',
            'lua',
            'markdown',
            'markdown_inline',
            'nix',
            'python',
            'regex',
            'rst',
            'rust',
            'toml',
            'tsx',
            'typescript',
            'yaml',
            'vim',
            'vimdoc',
        },
        highlight = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                node_decremental = '<c-h>', -- NOTE: <c-h> same as <c-backspace> in temrinal
            },
        },
        textobjects = { enable = false },
        indent = { enable = true },
    },
}
