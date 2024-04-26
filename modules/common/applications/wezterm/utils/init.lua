local M = {}

function M.is_vim(pane)
	-- depends on smart-split plugin
	return pane:get_user_vars().IS_NVIM == "true"
end

function M.find_vim_pane(tab)
	for _, pane in ipairs(tab:panes()) do
		if M.is_vim(pane) then
			return pane
		end
	end
end

return M
