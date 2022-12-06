local M = {}

function M.setup()
   -- Indicate first time installation
   local packer_bootstrap = false

   -- packer.nvim configuration
   local conf = {
      max_jobs = 30, -- needed so packer doesn't hang when >70 plugins are around
      profile = {
         enable = true,
         threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
      },

      display = {
         open_fn = function()
            return require("packer.util").float { border = "rounded" }
         end,
      },
   }

   -- Check if packer.nvim is installed
   -- Run PackerCompile if there are changes in this file
   local function packer_init()
      local fn = vim.fn
      local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
      if fn.empty(fn.glob(install_path)) > 0 then
         packer_bootstrap = fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
         }
         vim.cmd [[packadd packer.nvim]]
      end

      -- Run PackerCompile if there are changes in this file
      local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
      vim.api.nvim_create_autocmd(
         { "BufWritePost" },
         { pattern = "init.lua", command = "source <afile> | PackerCompile", group = packer_grp }
      )
   end

   -- Plugins
   local function plugins(use)
      use { "wbthomason/packer.nvim" }

      -- Performance
      use { "lewis6991/impatient.nvim" }

      -- Load only when require
      use { "nvim-lua/plenary.nvim", module = "plenary" }

      -- file icons
      use {
         "nvim-tree/nvim-web-devicons",
         module = "nvim-web-devicons",
         config = function()
            require("nvim-web-devicons").setup { default = true }
         end,
      }

      -- Status line
      use {
         "nvim-lualine/lualine.nvim",
         event = "BufReadPre",
         config = function()
            require("config.lualine").setup()
         end,
      }

      -- file explorer
      -- nvim-tree
      use {
         "nvim-tree/nvim-tree.lua",
         opt = true,
         cmd = { "NvimTreeToggle", "NvimTreeClose" }, -- changes root dir to git root on open
         config = function()
            require("config.nvimtree").setup()
         end,
      }
      -- ranger
      use {
         "kevinhwang91/rnvimr"
      }
      use { "is0n/fm-nvim" }

      -- Treesitter
      use {
         "nvim-treesitter/nvim-treesitter",
         run = ":TSUpdate",
         config = function()
            require("config.treesitter").setup()
         end,
         requires = {
            { "RRethy/nvim-treesitter-textsubjects", event = "BufReadPre" },
         }

      }

      use {
         'numToStr/Comment.nvim',
         config = function()
            require('Comment').setup()
         end
      }

      use { "rcarriga/nvim-notify" }

      use {
         "nvim-telescope/telescope.nvim",
         event = { "VimEnter" },
         config = function()
            require("config.telescope").setup()
         end,
         requires = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            {
               "ahmedkhalf/project.nvim",
               config = function()
                  require("config.project").setup()
               end,
            },
            "jvgrootveld/telescope-zoxide",
         }
      }

      -- LSP, auto completion, snippets
      use({
         "VonHeikemen/lsp-zero.nvim",
         requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jose-elias-alvarez/null-ls.nvim" },
            { "lukas-reineke/lsp-format.nvim", config = function()
               require("lsp-format").setup()
            end },
            { "SmiteshP/nvim-navic",
               config = function()
                  require("nvim-navic").setup()
               end
            },
            {
               "ray-x/lsp_signature.nvim",
               config = function()
                  require("lsp_signature").setup {
                     hint_enable = false
                  }
               end
            },
            {
               "j-hui/fidget.nvim",
               config = function()
                  require("fidget").setup()
               end
            },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            {
               "windwp/nvim-autopairs",
               config = function()
                  require("nvim-autopairs").setup()
               end
            },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },

            -- AI assistance
            {
               "zbirenbaum/copilot.lua",
               event = "VimEnter",
               requires = "zbirenbaum/copilot-cmp",
               config = function()
                  vim.defer_fn(function()
                     require("config.copilot").setup()
                  end, 100)
               end
            }
         },
         config = require("config.lsp").setup()
      })

      use({
         "folke/trouble.nvim",
         requires = "kyazdani42/nvim-web-devicons",
         config = function()
            require("trouble").setup()
         end
      })

      use {
         "folke/which-key.nvim",
         event = "VimEnter",
         module = { "which-key" },
         config = function()
            require("config.whichkey").setup()
         end
      }

      use {
         "sidebar-nvim/sidebar.nvim",
         config = require("config.sidebar").setup()
      }


      -- Rust
      use {
         "simrat39/rust-tools.nvim",
         requires = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
         -- opt = true,
         -- module = "rust-tools",
         -- ft = { "rust" },
      }
      use {
         "saecki/crates.nvim",
         event = { "BufRead Cargo.toml" },
         requires = { { "nvim-lua/plenary.nvim" } },
         config = function()
            -- local null_ls = require "null-ls"
            require("crates").setup {
               null_ls = {
                  enabled = true,
                  name = "crates.nvim",
               },
            }
         end,
      }

      -- Debugging
      use {
         "mfussenegger/nvim-dap",
         opt = true,
         keys = { [[<leader>d]] },
         module = { "dap" },
         wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
         requires = {
            -- "alpha2phi/DAPInstall.nvim",
            -- { "Pocco81/dap-buddy.nvim", branch = "dev" },
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
         },
         config = function()
            require("config.dap").setup()
         end,
      }

      -- Test
      use {
         "nvim-neotest/neotest",
         opt = true,
         wants = {
            "plenary.nvim",
            "nvim-treesitter",
            "FixCursorHold.nvim",
            "neotest-python",
            "neotest-plenary",
            "neotest-go",
            "neotest-jest",
            "neotest-vim-test",
            "neotest-rust",
            "vim-test",
            "overseer.nvim",
         },
         requires = {
            "vim-test/vim-test",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-go",
            "haydenmeade/neotest-jest",
            "nvim-neotest/neotest-vim-test",
            "rouge8/neotest-rust",
            "stevearc/overseer.nvim",
         },
         module = { "neotest", "neotest.async" },
         cmd = {
            "TestNearest",
            "TestFile",
            "TestSuite",
            "TestLast",
            "TestVisit",
         },
         config = function()
            require("config.neotest").setup()
         end,
         disable = false,
      }

      -- code assistance
      use {
         'sudormrfbin/cheatsheet.nvim',
         requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
         },
         config = function()
            require("cheatsheet").setup()
         end
      }

      -- terminal in nvim
      use {
         "akinsho/toggleterm.nvim",
         tag = '*',
         config = function()
            require("toggleterm").setup()
         end
      }

      -- Git stuff
      use {
         'lewis6991/gitsigns.nvim',
         config = function()
            require('config.gitsigns').setup()
         end
      }

      -- direnv
      use { "direnv/direnv.vim" }

      -- Diffview
      use {
         "sindrets/diffview.nvim",
         requires = "nvim-lua/plenary.nvim",
         cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
         config = function()
            require("diffview").setup {
               view = { merge_tool = { layout = "diff4_mixed" } }
            }
         end
      }

      -- note taking
      use {
         'nvim-orgmode/orgmode',
         requires = "nvim-treesitter/nvim-treesitter",
         config = function()
            require('config.orgmode').setup()
         end
      }

      -- latex fomulae rendering
      use { "jbyuki/nabla.nvim" }

      -- colorschemes
      use({
         "folke/tokyonight.nvim",
         config = require("config.colorschemes.tokyonight").setup(),
         disable = _G.LJ.colorscheme ~= "tokyonight"
      })

      use {
         "folke/todo-comments.nvim",
         requires = "nvim-lua/plenary.nvim",
         config = function()
            require("todo-comments").setup()
         end
      }

      -- focus mode
      use({
         "Pocco81/true-zen.nvim",
         config = function()
            require("config.truezen").setup()
         end,
      })

      -- Bootstrap Neovim
      if packer_bootstrap then
         print "Neovim restart is required after installation!"
         require("packer").sync()
      end
   end

   -- Init and start packer
   packer_init()
   local packer = require "packer"

   -- Performance
   pcall(require, "impatient")
   -- pcall(require, "packer_compiled")

   packer.init(conf)
   packer.startup(plugins)
end

return M
