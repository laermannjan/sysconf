local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", default_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Center search results
keymap("n", "n", "nzz", default_opts)
keymap("n", "N", "Nzz", default_opts)

-- keep text selected when in-/dedenting and all to repeatedly indent
keymap("v", "<", "<gv", default_opts)
keymap("v", ">", ">gv", default_opts)

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', default_opts)

-- Cancel search highlighting with ESC
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	vim.notify("Could not load which-key!")
	return
end

local conf = {
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
	},
}

local opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local mappings = {
	["w"] = { "<cmd>update!<CR>", "Save" },
	["q"] = { "<cmd>lua require('lj.utils').smart_quit()<cr>", "Quit" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle explorer" },
	["/"] = { "<cmd>Telescope live_grep<cr>", "grep in cwd" },

	b = {
		name = "Buffer",
		c = { "<cmd>bd!<cr>", "Close current buffer" },
		D = { "<cmd>%bd|e#|bd#<cr>", "Delete all buffers" },
	},

	f = {
		name = "Find",
		f = { "<cmd>Telescope find_files<cr>", "search files" },
		s = { "<cmd>Telescope grep_string<cr>", "string under cursor in cwd" },
		h = { "<cmd>Telescope help_tags<cr>", "list available help tags" },
	},

	g = {
		name = "Git",
		g = { "<cmd>LazyGitToggle<cr>", "LazyGit" },
		G = { "<cmd>NeoGitToggle<cr>", "NeoGit" },
	},

	s = {
		name = "Splits",
		v = { "<C-w>v", "split vertically" },
		V = { "<C-w>h", "split horizontally" },
		e = { "<C-w>=", "equalize size" },
		x = { "<cmd>close<cr>", "close split" },
	},

	z = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		z = { "<cmd>PackerSync<cr>", "Sync" },
		s = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},
}

wk.setup(conf)
wk.register(mappings, opts)
