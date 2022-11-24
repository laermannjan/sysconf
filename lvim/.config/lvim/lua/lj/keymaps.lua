lvim.leader = "space"
lvim.keys.visual_mode["p"] = '"_dP' -- don't copy what I overwrite with paste
lvim.builtin.which_key.mappings['x'] = { "<cmd>BufferKill<CR>", "Close Buffer" }
lvim.builtin.which_key.mappings['X'] = { "<cmd>BufferCloseAllButCurrent<CR>", "Close All But Current Buffer" }
lvim.builtin.which_key.mappings["gG"] = { "<cmd>Neogit<cr>", "Neogit" }
