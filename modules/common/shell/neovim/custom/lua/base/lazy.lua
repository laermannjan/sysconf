local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}

	local oldcmdheight = vim.opt.cmdheight:get()
	vim.opt.cmdheight = 1
	vim.notify "Please wait while plugins are installed..."
	vim.api.nvim_create_autocmd("User", {
		desc = "Load Mason and Treesitter after Lazy installs plugins",
		once = true,
		pattern = "LazyInstall",
		callback = function()
			vim.cmd.bw()
			vim.opt.cmdheight = oldcmdheight
			vim.tbl_map(function(module)
				pcall(require, module)
			end, { "nvim-treesitter", "mason" })
			-- Note: This event will also trigger a Mason update in distroupdate.nvim
		end,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
	spec = { import = "plugins" },
	defaults = { lazy = true },
	-- install = {
	-- 	colorscheme = { "tokyonight", "default" },
	-- },
	-- ui = {
	-- 	border = "rounded",
	-- },
	performance = {
		rtp = { -- Use deflate to download faster from the plugin repos.
			disabled_plugins = {
				"tohtml",
				"gzip",
				"zipPlugin",
				"netrwPlugin",
				"tarPlugin",
			},
		},
	},
	change_detection = {
		enabled = false,
		notify = false,
	},
}
