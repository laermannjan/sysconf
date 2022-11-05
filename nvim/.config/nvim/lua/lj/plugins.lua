-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return packer.startup(function(use)
	-- packer can manage itself
	use({ "wbthomason/packer.nvim" })

	-- byte compiled caching for modules/plugins to speedup startup time (no need to lazy-load anymore)
	use({
		"lewis6991/impatient.nvim",
		config = function()
			require("impatient")
		end,
	})

	use({ "nvim-lua/plenary.nvim" })

	-- colorschemes
	use({ "folke/tokyonight.nvim" })

	-- keymaps
	use({ "folke/which-key.nvim" })

	-- comment things with `gc`
	use({ "numToStr/Comment.nvim" })

	-- parser that generates syntax trees to be used by other plugins, e.g. to provide semantical meaning via highlight
	-- groups in themes
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	-- allows for extra motions with semantic meaning, like "within a class" or "around a function"
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })

	-- pairs and surroundings
	use({ "kylechui/nvim-surround" })

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
	use({ "SmiteshP/nvim-navic" }) -- shows code context based on LSP, like vscode breadcrumbs
	use("j-hui/fidget.nvim") -- show a little info at the bottom right, when LSPs are loading

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- outline with :SymbolsOutline
	use("simrat39/symbols-outline.nvim") -- TODO: highlights are not working

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		config = function()
			require("nvim-tree").setup()
		end,
	})

	-- statusline
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
