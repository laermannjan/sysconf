require("config")
vim.g.python3_host_prog = "~/.pyenv/versions/neovim/bin/python"
vim.g.flabber__diagnostics_signs = {
    error = " ",
    warning = " ",
    hint = " ",
    information = " ",
    other = "",
}
vim.cmd [[colorscheme kanagawa]]
