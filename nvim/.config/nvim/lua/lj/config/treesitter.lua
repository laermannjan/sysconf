local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

treesitter.setup({
    ensure_installed = "all", -- no need to not install some grammars
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },

    autotag = { enable = true }, -- auto tag closing with nvim-ts-autotag

    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["aC"] = "@class.outer", 
                  ["iC"] = "@class.inner",
                  ["ac"] = "@call.outer",
                  ["ic"] = "@call.inner",
                  ["ap"] = "@parameter.outer",
                  ["ip"] = "@parameter.inner",
                  ["al"] = "@loop.outer", 
                  ["il"] = "@loop.inner",
                  ["ai"] = "@conditional.outer",
                  ["ii"] = "@conditional.inner",
                  ["a/"] = "@comment.outer",
                  ["i/"] = "@comment.inner",
                  ["aa"] = "@attribute.outer",
                  ["ia"] = "@attribute.inner",
            },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>r<tab>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>r<S-tab>"] = "@parameter.inner",
          },
        },
    }

})


