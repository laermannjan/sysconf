S = {}
-- S.colorscheme = "tokyonight"
S.colorscheme = "tokyodark"
-- S.colorscheme = "nightfox"
-- S.colorscheme = "duskfox"
-- S.colorscheme = "terafox"
-- S.colorscheme = "nordic"

require "user.spec"
require "user.options"
require "user.keymaps"
require "user.autocmds"

spec "user.colorschemes"
spec "user.devicons"
spec "user.treesitter"
spec "user.lsp"
spec "user.none-ls"
spec "user.cmp"
spec "user.which-key"
-- spec "user.snap" -- telescope alternative
spec "user.telescope"
spec "user.trouble"
spec "user.neotree"
-- spec "user.nvim-tree"
spec "user.comment"
spec "user.fidget"
spec "user.neotab"
spec "user.todo-comments"

-- todo
-- spec "user.harpooon"
-- spec "user.ufo" -- TODO: see launch.nvim config
--
spec "user.copilot"
spec "user.neogit"
-- spec "user.gitlinker"
spec "user.gitsigns"
-- spec "user.diffview"
spec "user.autopairs"
--
spec "user.lualine"
-- spec "user.project"
spec "user.toggleterm"

spec "user.neotest"

spec "user.various-textobjects"
require "user.lazy"
