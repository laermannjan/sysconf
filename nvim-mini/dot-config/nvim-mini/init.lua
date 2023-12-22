vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.undofile = true
vim.o.hlsearch = true
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4


-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<ESC>', '<cmd>noh<cr><ESC>', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'goto previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'goto next diagnostic message' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'open floating diagnostic message' })
vim.keymap.set('n', '<leader>l', "<cmd>Lazy<cr>", { desc = 'open floating diagnostic message' })


local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'tpope/vim-sleuth' },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    -- theme
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        variant = 'main',
        -- dim_nc_background=true,
        disable_background = false,
        disable_italics = true,
      })
      vim.cmd.colorscheme 'rose-pine'
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },


  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',

      -- beancount
      "crispgm/cmp-beancount",
    },
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   config = function()
  --     local null_ls = require("null-ls")
  --
  --     null_ls.setup({
  --       sources = {
  --         null_ls.builtins.formatting.stylua,
  --         null_ls.builtins.formatting.gofumpt,
  --         null_ls.builtins.formatting.goimports,
  --         null_ls.builtins.code_actions.gomodifytags,
  --         null_ls.builtins.code_actions.impl,
  --         -- null_ls.builtins.diagnostics.ruff,
  --         -- null_ls.builtins.formatting.ruff,
  --         -- null_ls.builtins.formatting.ruff_format,
  --         null_ls.builtins.completion.spell,
  --       },
  --     })
  --   end,
  -- },

  { "github/copilot.vim" },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        fish = { "fish_indent" },
        sh = { "shfmt" },
        go = { "goimports", "gofumpt" },
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff_format", "ruff_fix" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        ["_"] = { "trim_whitespace" },
      },

      formatters = {
        ruff_fix = {
          prepend_args = { "--select", "I" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },

      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_fallback = true,
        timeout_ms = 500,
      },
    }
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        fish = { "fish", },
        zsh = { "zsh", },
        python = { "mypy", },
      },
      linters = {
        fish = {
          cmd = "/opt/homebrew/bin/fish",
        }
      },

    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft or {}
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end


      vim.api.nvim_create_autocmd(opts.events, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },


  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({})
    end,
    keys = {
      { "<C-h>", function()
        local harpoon = require('harpoon')
        if harpoon.ui.win_id == nil then
          harpoon:list():append()
        end
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, "Harpoon Quick Menu" },
      { "<tab>j", function()
        local harpoon = require('harpoon')
        harpoon:list():select(1)
      end, "Harpoon Select 1" },
      { "<tab>k", function()
        local harpoon = require('harpoon')
        harpoon:list():select(2)
      end, "Harpoon Select 2" },
      { "<tab>l", function()
        local harpoon = require('harpoon')
        harpoon:list():select(3)
      end, "Harpoon Select 3" },
      { "<tab>;", function()
        local harpoon = require('harpoon')
        harpoon:list():select(4)
      end, "Harpoon Select 4" },
    },
  },

  {
    'folke/flash.nvim',
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = false,
        }
      }
    },
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" }, }
  },

  { 'echasnovski/mini.files', version = false, opts = {} },
  { 'echasnovski/mini.pick',  version = false, opts = {} },
  { 'echasnovski/mini.extra', version = false, opts = {} },
  { 'onsails/lspkind.nvim' },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<leader>e", mode = { "n" }, "<cmd>Neotree toggle<CR>", desc = "Neotree" }
    },

  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
    keys = {
      { "<leader>gb",  "<cmd>Gitsigns blame_line<cr>",                desc = "blame line" },
      { "<leader>gd",  "<cmd>Gitsigns diffthis<cr>",                  desc = "git diff against base" },
      { "<leader>ugb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "toggle current blame line" },
      { "<leader>ugd", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "toggle current blame line" },
    }
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "previous todo comment" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>",                            desc = "find todo commends" },
    }
  },
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    version = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        enabled = vim.fn.executable('make') == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end
      },
    },
    keys = {
      { "<leader>ff",       function() require("telescope.builtin").git_files({ show_untracked = true }) end,                                desc = "find git files" },
      { "<leader>fF",       function() require('telescope.builtin').find_files() end,                                                        desc = "find files" },
      { "<leader>fc",       function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath("config") }) end,                      desc = "find in nvim config" },
      { "<leader>fC",       function() require('telescope.builtin').find_files({ cwd = vim.fn.expand("$HOME/.config"), follow = true }) end, desc = "find in XDG_CONFIG" },
      { "<leader>fr",       function() require('telescope.builtin').oldfiles() end,                                                          desc = "recent files" },
      { "<leader>fw",       function() require('telescope.builtin').grep_string() end,                                                       desc = "find word in files" },
      { "<leader>fw",       function() require('telescope.builtin').grep_string() end,                                                       mode = "v",                     desc = "find selection in files" },
      { "<leader>fh",       function() require('telescope.builtin').help_tags() end,                                                         desc = "find help tag" },
      { "<leader>fk",       function() require('telescope.builtin').keymaps() end,                                                           desc = "find keymaps" },
      { "<leader>uc",       function() require('telescope.builtin').colorscheme({ enable_preview = true }) end,                              desc = "preview colorschemes" },
      { "<leader>\\",       function() require('telescope.builtin').builtin() end,                                                           desc = "find telescope command" },
      { "<leader><leader>", function() require('telescope.builtin').resume() end,                                                            desc = "resume last search" },
    },
    opts = function()
      local trouble = require("trouble.providers.telescope")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({ no_ignore = true, no_ignore_parents = true, default_text = line })
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({ hidden = true, default_text = line })
      end
      return {
        defaults = {
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
            },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end
  },
})


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})



-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner'
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)




-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local lsp_keymaps = {
    { 'gd',         function() require('telescope.builtin').lsp_definitions() end,               'goto definition' },
    { 'gr',         function() require('telescope.builtin').lsp_references() end,                'goto references' },
    { 'gI',         function() require('telescope.builtin').lsp_implementations() end,           'goto implementations' },
    { 'gy',         function() require('telescope.builtin').lsp_type_definitions() end,          'goto type definitions' },
    { '<leader>cs', function() require('telescope.builtin').lsp_document_symbols() end,          'document symbols' },
    { '<leader>cS', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 'workspace symbols' },
    { '<leader>cr', vim.lsp.buf.rename,                                                          'rename symbols' },
    { '<leader>ca', vim.lsp.buf.code_action,                                                     'code actions' },
    { 'K',          vim.lsp.buf.hover,                                                           'hover information' },
    { '<C-k>',      vim.lsp.buf.signature_help,                                                  mode = { 'n', 'i' },    'signature help' },

  }


  if client.name == "ruff_lsp" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end

  local Keys = require("lazy.core.handler.keys")
  for _, key in pairs(Keys.resolve(lsp_keymaps)) do
    vim.keymap.set(key.mode or "n", key.lhs, key.rhs, Keys.opts(key))
  end
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  gopls = {},
  ruff_lsp = {
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      }
    }
  },
  pyright = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
      }
    }
  },
  rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    },
    ['<Tab>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text',  -- show only symbol annotations
      maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      }),

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    {
      name = "beancount",
      option = {
        account = "~/Documents/Finanzen/Haushaltsbuch/new_beans/ledger/main.beancount",
      },
    },
    { name = 'luasnip' },
  },
}
