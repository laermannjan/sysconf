-- quickly increment/decrement or cycle through options for a textobject (e.g. cycle through weekdays or true/false)
--
table.insert(lvim.plugins, "monaqa/dial.nvim")

local M = {}
M.setup = function()
    local status_ok, dial_config = pcall(require, "dial.config")
    if not status_ok then
        return
    end

    local augend = require "dial.augend"
    local maps = {
        augend.constant.new {
            elements = { "and", "or" },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
        },
        augend.constant.new {
            elements = { "True", "False" },
            word = true,
            cyclic = true,
        },
        augend.constant.new {
            elements = { "public", "private" },
            word = true,
            cyclic = true,
        },
        augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
        },
        augend.constant.new {
            elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
            word = true,
            cyclic = true,
        },
        augend.case.new { types = { "camelCase", "PascalCase", "kebab-case", "snake_case", "SCREAMING_SNAKE_CASE" } },
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%d.%m.%Y"],
        augend.date.alias["%H:%M"],
        augend.date.alias["%H:%M:%S"],
        augend.constant.alias.de_weekday_full,
        augend.constant.alias.bool,
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.hexcolor.new { case = "upper" },
        augend.semver.alias.semver
    }


    dial_config.augends:register_group {
        default = maps,
        visual = maps,
        mygroup = maps,
    }


    lvim.keys.normal_mode["<C-a>"] = require("dial.map").inc_normal("mygroup")
    lvim.keys.normal_mode["<C-x>"] = require("dial.map").dec_normal("mygroup")
    lvim.keys.visual_mode["<C-a>"] = require("dial.map").inc_visual("mygroup")
    lvim.keys.visual_mode["<C-x>"] = require("dial.map").dec_visual("mygroup")
    lvim.keys.visual_mode["g<C-a>"] = require("dial.map").inc_gvisual("mygroup")
    lvim.keys.visual_mode["g<C-x>"] = require("dial.map").dec_gvisual("mygroup")
end

M.setup()
