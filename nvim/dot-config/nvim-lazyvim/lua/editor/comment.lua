return {
  "echasnovski/mini.comment",
  opts = {
    options = {
      custom_commentstring = function()
        if vim.bo.filetype == "beancount" then
          return "; %s"
        end
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  },
}
