-- when using async format on save `:wq` does not save the formatted version
-- this forces :wq to format syncronuously
vim.cmd [[cabbrev wq execute "Format sync" <bar> wq]]
