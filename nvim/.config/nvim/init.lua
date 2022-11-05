--           _____            _____
--          /\    \          /\    \
--         /::\____\        /::\    \
--        /:::/    /        \:::\    \
--       /:::/    /          \:::\    \
--      /:::/    /            \:::\    \
--     /:::/    /              \:::\    \
--    /:::/    /               /::::\    \
--   /:::/    /       _____   /::::::\    \
--  /:::/    /       /\    \ /:::/\:::\    \
-- /:::/____/       /::\    /:::/  \:::\____\
-- \:::\    \       \:::\  /:::/    \::/    /
--  \:::\    \       \:::\/:::/    / \/____/
--   \:::\    \       \::::::/    /
--    \:::\    \       \::::/    /
--     \:::\    \       \::/    /
--      \:::\    \       \/____/
--       \:::\    \
--        \:::\____\
--         \::/    /
--          \/____/
--
require("globals")
require("options")
require("mappings")
require("plugins")

-- require("config/bufferline")
require("config/better-escape")
require("config/lualine")
require("config/comment")
require("config/cmp")
-- require("config/dashboard")
require("config/diffview")
require("config/gitsigns")
require("config/neogit")
require("config/neoscroll")
require("config/indent-blankline")
require("config/keys")
require("config/window-navigator")
require("config/nvim-autopairs")
require("config/nvim-colorizer")
require("config/nvim-dap-ui")
require("config/nvim-ts-autotag")
require("config/nvim-lightbulb")
require("config/twilight")
require("config/trouble")
require("config/rust-tools")
require("config/snippets")
require("config/specs")
require("config/telescope")
require("config/todo-comments")
require("config/tree-sitter")
require("config/which-key")
require("config/zen-mode")

vim.cmd("colorscheme base16-gruvbox-dark-hard")
