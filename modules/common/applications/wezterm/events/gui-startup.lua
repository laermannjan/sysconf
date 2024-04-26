local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

function M.setup()
	wezterm.on("gui-startup", function()
		local tab, pane, window = mux.spawn_window({})
		window:gui_window():maximize()
	end)
end

return M
