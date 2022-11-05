table.insert(lvim.plugins, { "karb94/neoscroll.nvim", disabled = lvim.lj.smooth_scroll ~= "neoscroll" })
table.insert(lvim.plugins, { "declancm/cinnamon.nvim", disabled = lvim.lj.smooth_scroll ~= "cinnamon" })

local M_neoscroll = {}
M_neoscroll.setup = function()
  local status_ok, neoscroll = pcall(require, "neoscroll")
  if not status_ok then
    return
  end

  neoscroll.setup {
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { "J", "K", "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
    -- easing_function = nil, -- Default easing function
    -- pre_hook = nil, -- Function to run before the scrolling animation starts
    -- post_hook = nil, -- Function to run after the scrolling animation ends
  }

  local t = {}
  -- Syntax: t[keys] = {function, {function arguments}}
  -- t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
  -- t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '250'}}
  -- t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
  -- t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450'}}
  -- t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
  -- t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
  -- t['H'] = {'scroll', {'-0.10', 'true', '100'}}
  -- t['L'] = {'scroll', { '0.10', 'true', '100'}}
  t["K"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
  t["J"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
  -- t['zt']    = {'zt', {'250'}}
  -- t['zz']    = {'zz', {'250'}}
  -- t['zb']    = {'zb', {'250'}}

  require("neoscroll.config").set_mappings(t)
end

local M_cinnamon = {}
M_cinnamon.setup = function()
  local status_ok, cinnamon = pcall(require, "cinnamon")
  if not status_ok then
    return
  end

  cinnamon.setup {
    -- KEYMAPS:
    default_keymaps = true, -- Create default keymaps.
    extra_keymaps = true, -- Create extra keymaps.
    extended_keymaps = false, -- Create extended keymaps.
    override_keymaps = false, -- The plugin keymaps will override any existing keymaps.

    -- OPTIONS:
    always_scroll = false, -- Scroll the cursor even when the window hasn't scrolled.
    centered = true, -- Keep cursor centered in window when using window scrolling.
    default_delay = 4, -- The default delay (in ms) between each line when scrolling.
    hide_cursor = true, -- Hide the cursor while scrolling. Requires enabling termguicolors!
    horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
    max_length = 150, -- Maximum length (in ms) of a command. The line delay will be
    -- re-calculated. Setting to -1 will disable this option.
    scroll_limit = 250, -- Max number of lines moved before scrolling is skipped. Setting
    -- to -1 will disable this option.
  }

  -- Scroll(arg1, arg2, arg3, arg4)
  -- arg1 = A string containing the normal mode movement commands. Look at the 'Keymaps' section for examples.
  -- -- To use the go-to-definition LSP function, use 'definition' (or 'declaration' for go-to-declaration).
  -- arg2 = Scroll the window with the cursor. (1 for on, 0 for off). Default is 0.
  -- arg3 = Accept a count before the command (1 for on, 0 for off). Default is 0.
  -- arg4 = Length of delay between each line (in ms). Setting to -1 will use the 'default_delay' config value. Default is -1.

  -- SCROLL_WHEEL_KEYMAPS:
  vim.keymap.set({ 'n', 'x' }, '<ScrollWheelUp>', "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
  vim.keymap.set({ 'n', 'x' }, '<ScrollWheelDown>', "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")

  -- LSP_KEYMAPS:
  lvim.lsp.buffer_mappings.normal_mode['gd'] = { "<Cmd>lua Scroll('definition')<CR>", "Go to definition" }
  lvim.lsp.buffer_mappings.normal_mode['gD'] = { "<Cmd>lua Scroll('declaration')<CR>", "Go to declaration" }
  lvim.keys.normal_mode['J'] = "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>"
  lvim.keys.normal_mode['K'] = "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>"
  lvim.lsp.buffer_mappings.normal_mode['gk'] = { vim.lsp.buf.hover, "Show hover" }
  lvim.lsp.buffer_mappings.normal_mode['K'] = nil
end

local M = {}
if lvim.lj.smooth_scroll == "cinnamon" then
  M = M_cinnamon
elseif lvim.lj.smooth_scroll == "neoscroll" then
  M = M_neoscroll
else
  return
end

M.setup()
