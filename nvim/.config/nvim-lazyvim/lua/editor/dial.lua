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
        augend.date.new({
          pattern = "%Y.%m.%d",
          default_kind = "day",
          -- if true, it does not match dates which does not exist, such as 2022/05/32
          only_valid = true,
          -- if true, it only matches dates with word boundary
          word = false,

          augend.constant.alias.bool,
        }),
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%d.%m.%Y"],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.integer.alias.decimal,
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
