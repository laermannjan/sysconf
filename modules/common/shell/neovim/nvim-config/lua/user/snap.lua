local M = {
	"camspiers/snap",
	dependencies = {
		{ "camspiers/luarocks", opts = { rocks = { "fzy" } } },
	},
}

M.config = function()
	-- Basic example config
	local snap = require "snap"
	snap.maps {
		{
			"<leader>ff",
			snap.config.file {
				prompt = "Find Files",
				producer = snap.get "consumer.fzy"(snap.get "producer.ripgrep.file"),
				select = snap.get("select.file").select,
				multiselect = snap.get("select.file").multiselect,
				views = { snap.get "preview.file" },
			},
		},
		{
			"<leader>/",
			snap.config.vimgrep {
				prompt = "Live Grep",
				producer = snap.get "consumer.limit"(10000, snap.get "producer.ripgrep.vimgrep"),
				select = snap.get("select.vimgrep").select,
				multiselect = snap.get("select.vimgrep").multiselect,
				views = { snap.get "preview.vimgrep" },
			},
		},

		{
			"<leader>ft",
			snap.config.file {
				producer = snap.get "consumer.fzy" {
					snap.get "consumer.try" {
						snap.get "producer.git.file",
						snap.get "producer.ripgrep.file",
					},
				},
				select = snap.get("select.file").select,
				multiselect = snap.get("select.file").multiselect,
				views = { snap.get "preview.file" },
			},
		},
		{
			"<leader>fh",
			snap.config.file {
				prompt = "Help>",
				producer = snap.get "consumer.fzy"(snap.get "producer.vim.help"),
				reverse = true,
				select = snap.get("select.help").select,
				views = { snap.get "preview.help" },
			},
		},
		--	{ "<Leader>ff", snap.config.file { producer = "ripgrep.file", args = { "--hidden", "--iglob", "!.git/*" } } },
	}
end

return M
