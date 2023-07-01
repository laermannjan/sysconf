return {
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    enabled = false,
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = function()
      local icons = require("lazyvim.config").icons
      require("symbols-outline").setup({
        position = "right",
        symbols = {
          File = { icon = icons.kinds.File, hl = "@text.uri" },
          Module = { icon = icons.kinds.Module, hl = "@namespace" },
          Namespace = { icon = icons.kinds.Namespace, hl = "@namespace" },
          Package = { icon = icons.kinds.Package, hl = "@namespace" },
          Class = { icon = icons.kinds.Class, hl = "@type" },
          Method = { icon = icons.kinds.Method, hl = "@method" },
          Property = { icon = icons.kinds.Property, hl = "@method" },
          Field = { icon = icons.kinds.Field, hl = "@field" },
          Constructor = { icon = icons.kinds.Constructor, hl = "@constructor" },
          Enum = { icon = icons.kinds.Enum, hl = "@type" },
          Interface = { icon = icons.kinds.Interface, hl = "@type" },
          Function = { icon = icons.kinds.Function, hl = "@function" },
          Variable = { icon = icons.kinds.Variable, hl = "@constant" },
          Constant = { icon = icons.kinds.Constant, hl = "TSConstant" },
          String = { icon = icons.kinds.String, hl = "@string" },
          Number = { icon = icons.kinds.Number, hl = "@number" },
          Boolean = { icon = icons.kinds.Boolean, hl = "@boolean" },
          Array = { icon = icons.kinds.Array, hl = "@constant" },
          Object = { icon = icons.kinds.Object, hl = "@type" },
          Key = { icon = icons.kinds.Key, hl = "@type" },
          Null = { icon = icons.kinds.Null, hl = "@type" },
          EnumMember = { icon = icons.kinds.EnumMember, hl = "@field" },
          Struct = { icon = icons.kinds.Struct, hl = "@type" },
          Event = { icon = icons.kinds.Event, hl = "@type" },
          Operator = { icon = icons.kinds.Operator, hl = "@operator" },
          TypeParameter = { icon = icons.kinds.TypeParameter, hl = "@parameter" },
          Component = { icon = icons.kinds.Component, hl = "@function" },
          Fragment = { icon = icons.kinds.Fragment, hl = "@constant" },
        },
      })
    end,
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = { { "<leader>cs", "<cmd>AerialToggle!<cr>", desc = "Symbols Outline" } },
    opts = {
      backends = { "lsp", "treesitterl", "markdown", "man" },
    },
  },
}
