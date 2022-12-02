local M = {}

local notify_present, notify = pcall(require, "notify")
if notify_present then
   vim.notify = notify
end

function M.is_empty(s)
   return s == nil or s == ""
end

function M.warn(msg, name)
   vim.notify(msg, "warn", { title = name })
end

function M.error(msg, name)
   vim.notify(msg, "error", { title = name })
end

function M.info(msg, name)
   vim.notify(msg, "info", { title = name })
end

function M.debug(msg, name)
   vim.notify(msg, "debug", { title = name })
end

function M.quit()
   local bufnr = vim.api.nvim_get_current_buf()
   local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
   if modified then
      vim.ui.input({
         prompt = "You have unsaved changes. What do you want to do? [q]uit, [w]rite&quit, abort: ",
      }, function(input)
         if input == "q" then
            vim.cmd "q!"
         elseif input == "w" then
            vim.cmd "wq"
         end
      end)
   else
      vim.cmd "q!"
   end
end

return M
