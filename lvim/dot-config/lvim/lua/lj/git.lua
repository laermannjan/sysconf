table.insert(lvim.plugins, { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' })

local neogit = reload("neogit")
neogit.setup()
