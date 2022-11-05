local ok, comment = pcall(require, "comment")
if not ok then
    vim.notify("Comment could not be required!")
    return
end

comment.setup()

