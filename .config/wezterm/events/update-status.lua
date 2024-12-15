local wezterm = require "wezterm"
local appearance = require "utils.appearance"
local umath = require "utils.math"

local nf = wezterm.nerdfonts

local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery,
}

local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_charging,
}

local M = {}

local function segments_for_right_status(window)
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ""
   local icon = ""

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge = string.format("%.0f%%", b.state_of_charge * 100)

      if b.state == "Charging" then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
      end
   end

   return {
      window:active_workspace(),
      wezterm.strftime "%a %b %-d %H:%M:%S",
      wezterm.hostname(),
      icon .. " " .. charge,
   }
end

M.setup = function()
   wezterm.on("update-right-status", function(window, _)
      local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
      local segments = segments_for_right_status(window)

      local color_scheme = window:effective_config().resolved_palette
      -- Note the use of wezterm.color.parse here, this returns
      -- a Color object, which comes with functionality for lightening
      -- or darkening the colour (amongst other things).
      local bg = wezterm.color.parse(color_scheme.background)
      local fg = color_scheme.foreground

      -- Each powerline segment is going to be coloured progressively
      -- darker/lighter depending on whether we're on a dark/light colour
      -- scheme. Let's establish the "from" and "to" bounds of our gradient.
      local gradient_to, gradient_from = bg
      if appearance.is_dark() then
         gradient_from = gradient_to:lighten(0.2)
      else
         gradient_from = gradient_to:darken(0.2)
      end

      -- Yes, WezTerm supports creating gradients, because why not?! Although
      -- they'd usually be used for setting high fidelity gradients on your terminal's
      -- background, we'll use them here to give us a sample of the powerline segment
      -- colours we need.
      local gradient = wezterm.color.gradient(
         {
            orientation = "Horizontal",
            colors = { gradient_from, gradient_to },
         },
         #segments -- only gives us as many colours as we have segments.
      )
      local elements = {}

      for i, seg in ipairs(segments) do
         local is_first = i == 1

         if is_first then
            table.insert(elements, { Background = { Color = "none" } })
         end
         table.insert(elements, { Foreground = { Color = gradient[i] } })
         table.insert(elements, { Text = SOLID_LEFT_ARROW })

         table.insert(elements, { Foreground = { Color = fg } })
         table.insert(elements, { Background = { Color = gradient[i] } })
         table.insert(elements, { Text = " " .. seg .. " " })
      end

      window:set_right_status(wezterm.format(elements))
   end)
end

return M ---@class WezTerm
