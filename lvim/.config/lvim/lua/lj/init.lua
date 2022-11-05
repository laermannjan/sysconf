-- table.insert(lvim.plugins, "vim-lua/plenary.nvim")
local plenary = reload "plenary"


if lvim.lj.autoload_configs then
    -- load all lua config files in this directory automatically
    local fileExtension = '.lua'
    local initFile = 'init.lua'

    local function isLuaFile(filename)
        return filename:sub(- #fileExtension) == fileExtension
    end

    local function loadAll(path, except)
        local scan = require('plenary.scandir')
        for _, file in ipairs(scan.scan_dir(path, { depth = 0 })) do

            if isLuaFile(file) and file:sub(- #initFile) ~= initFile then
                dofile(file)
            end
        end
    end

    loadAll("/Users/jan/.config/lvim/lua/lj")
end
