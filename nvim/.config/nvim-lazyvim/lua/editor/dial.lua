return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", mode = { "n", "v" } },
    { "<C-x>", mode = { "n", "v" } },
    { "g<C-a>", mode = { "v" } },
    { "g<C-x>", mode = { "v" } },
  },
  event = "VeryLazy",
  opts = function()
    local augend = require("dial.augend")
    local groups = {
      default = {
        augend.semver.alias.semver,
        augend.integer.alias.decimal,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
      },
    }
    return {
      groups = groups,
    }
  end,
    -- stylua: ignore
    config = function(_, opts)
        require("dial.config").augends:register_group(opts.groups)
        vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
        vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
    end,
}
