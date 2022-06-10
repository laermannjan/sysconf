local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

local presets = require("which-key.plugins.presets")
presets.objects["a("] = nil
wk.setup({
    show_help = true,
    triggers = "auto",
    plugins = { spelling = true },
    key_labels = { ["<leader>"] = "SPC" },
})

-- Move to window using the <ctrl> movement keys
util.nmap("<left>", "<C-w>h")
util.nmap("<down>", "<C-w>j")
util.nmap("<up>", "<C-w>k")
util.nmap("<right>", "<C-w>l")

-- Resize window using <ctrl> arrow keys
util.nnoremap("<S-Up>", ":resize +2<CR>")
util.nnoremap("<S-Down>", ":resize -2<CR>")
util.nnoremap("<S-Left>", ":vertical resize -2<CR>")
util.nnoremap("<S-Right>", ":vertical resize +2<CR>")

-- Move Lines
util.nnoremap("<A-j>", ":m .+1<CR>==")
util.vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
util.inoremap("<A-j>", "<Esc>:m .+1<CR>==gi")
util.nnoremap("<A-k>", ":m .-2<CR>==")
util.vnoremap("<A-k>", ":m '<-2<CR>gv=gv")
util.inoremap("<A-k>", "<Esc>:m .-2<CR>==gi")

util.nnoremap("<A-1>", "<esc><cmd>BufferGoto 1<cr>")
util.nnoremap("<A-2>", "<esc><cmd>BufferGoto 2<cr>")
util.nnoremap("<A-3>", "<esc><cmd>BufferGoto 3<cr>")
util.nnoremap("<A-4>", "<esc><cmd>BufferGoto 4<cr>")
util.nnoremap("<A-5>", "<esc><cmd>BufferGoto 5<cr>")
util.nnoremap("<A-6>", "<esc><cmd>BufferGoto 6<cr>")
util.nnoremap("<A-7>", "<esc><cmd>BufferGoto 7<cr>")
util.nnoremap("<A-8>", "<esc><cmd>BufferGoto 8<cr>")
util.nnoremap("<A-9>", "<esc><cmd>BufferGoto 9<cr>")
util.nnoremap("<A-0>", "<esc><cmd>BufferLast<cr>")
util.inoremap("<A-1>", "<esc><cmd>BufferGoto 1<cr>")
util.inoremap("<A-2>", "<esc><cmd>BufferGoto 2<cr>")
util.inoremap("<A-3>", "<esc><cmd>BufferGoto 3<cr>")
util.inoremap("<A-4>", "<esc><cmd>BufferGoto 4<cr>")
util.inoremap("<A-5>", "<esc><cmd>BufferGoto 5<cr>")
util.inoremap("<A-6>", "<esc><cmd>BufferGoto 6<cr>")
util.inoremap("<A-7>", "<esc><cmd>BufferGoto 7<cr>")
util.inoremap("<A-8>", "<esc><cmd>BufferGoto 8<cr>")
util.inoremap("<A-9>", "<esc><cmd>BufferGoto 9<cr>")
util.inoremap("<A-0>", "<esc><cmd>BufferLast<cr>")

-- Clear search with <esc>
util.map("", "<esc>", ":noh<cr>")

-- n always searches forward, N always backward
util.nnoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.xnoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.onoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.nnoremap("N", "'nN'[v:searchforward]", { expr = true })
util.xnoremap("N", "'nN'[v:searchforward]", { expr = true })
util.onoremap("N", "'nN'[v:searchforward]", { expr = true })

-- save in insert mode
util.inoremap("<C-s>", "<esc>:w<cr>")
util.nnoremap("<C-s>", "<esc>:w<cr>")

-- change word under cursor
util.nnoremap("<C-c>", "<esc>ciw")

-- better indenting
util.vnoremap("<", "<gv")
util.vnoremap(">", ">gv")

-- get a uniform random number
util.nnoremap("<space>cu", function()
    local number = math.random(math.pow(2, 127) + 1, math.pow(2, 128))
    return "i" .. string.format("%.0f", number)
end, {
    expr = true,
})


wk.register({
    ["]"] = {
        name = "next",
        r = { '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', "Next Reference" },
    },
    ["["] = {
        name = "previous",
        r = { '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', "Previous Reference" },
    },
})

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
    [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]]   ,
    false
)

local leader = {
    w = {
        name = "+windows",
        ["w"] = { "<C-W>p", "other-window" },
        ["d"] = { "<C-W>c", "delete-window" },
        ["h"] = { "<C-W>h", "window-left" },
        ["j"] = { "<C-W>j", "window-below" },
        ["l"] = { "<C-W>l", "window-right" },
        ["k"] = { "<C-W>k", "window-up" },
        ["H"] = { "<C-W>5<", "expand-window-left" },
        ["J"] = { ":resize +5", "expand-window-below" },
        ["L"] = { "<C-W>5>", "expand-window-right" },
        ["K"] = { ":resize -5", "expand-window-up" },
        ["="] = { "<C-W>=", "balance-window" },
        ["s"] = { "<C-W>s", "split-window-below" },
        ["v"] = { "<C-W>v", "split-window-right" },
    },
    b = {
        name = "+buffer",
        ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
        ["B"] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Show Buffers" },
        h = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
        l = { "<cmd>BufferNext<cr>", "Next Buffer" },
        H = { "<cmd>BufferMovePrevious<cr>", "Move Tab Right" },
        L = { "<cmd>BufferMoveNext<cr>", "Move Tab Left" },
        k = { "<cmd>BufferClose<cr>", "Kill Buffer" },
        K = { "<cmd>BufferCloseAllButCurrentOrPinned", "Kill all Others" },
        o = {
            name = "+order",
            b = { "<cmd>BufferOrderByBufferNumber<cr>", "by Buffer Number" },
            d = { "<cmd>BufferOrderByDirectory<cr>", "by Directory" },
            l = { "<cmd>BufferOrderByLanguage<cr>", "by Language" },
            w = { "<cmd>BufferOrderByWindowNumber<cr>", "by Window Number" },
        },
    },
    g = {
        name = "+git",
        g = { "<cmd>Neogit kind=split<CR>", "NeoGit" },
        l = {
            function()
                require("util").float_terminal("lazygit")
            end,
            "LazyGit",
        },
        c = { "<Cmd>Telescope git_commits<CR>", "commits" },
        b = { "<Cmd>Telescope git_branches<CR>", "branches" },
        s = { "<Cmd>Telescope git_status<CR>", "status" },
        d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
        h = { name = "+hunk" },
    },
    ["h"] = {
        name = "+help",
        t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
        c = { "<cmd>:Telescope commands<cr>", "Commands" },
        h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
        m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
        k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
        s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
        l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
        f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
        o = { "<cmd>:Telescope vim_options<cr>", "Options" },
        a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
        p = {
            name = "+packer",
            p = { "<cmd>PackerSync<cr>", "Sync" },
            s = { "<cmd>PackerStatus<cr>", "Status" },
            i = { "<cmd>PackerInstall<cr>", "Install" },
            c = { "<cmd>PackerCompile<cr>", "Compile" },
        },
    },
    s = {
        name = "+search",
        g = { "<cmd>Telescope live_grep<cr>", "Grep" },
        b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
        s = {
            function()
                require("telescope.builtin").lsp_document_symbols({
                    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait" },
                })
            end,
            "Goto Symbol",
        },
        h = { "<cmd>Telescope command_history<cr>", "Command History" },
        m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
        -- r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
    },
    f = {
        name = "+file",
        b = { "<cmd>RnvimrToggle<cr>", "Browse files (Ranger)" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- find a way to search from git root when present
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        n = { "<cmd>enew<cr>", "New File" },
        O = { "<cmd>SudaRead<cr>", "Reopen File with sudo" },
        s = { "<esc><cmd>w<cr>", "Save file" },
        S = { "<cmd>SudaWrite<cr>", "Save file with sudo" },
        z = "Zoxide",
        d = "Browse config files",
    },
    p = {
        name = "+project",
        p = "Open Project",
        a = { ":Telescope file_browser cwd=~/dev/alcemy<CR>", "Browse alcemy repos" },
        l = { ":Telescope file_browser cwd=~/dev/lj<CR>", "Browse private repos" },
    },
    t = {
        name = "toggle",
        f = {
            require("config.lsp.formatting").toggle,
            "Format on Save",
        },
        s = {
            function()
                util.toggle("spell")
            end,
            "Spelling",
        },
        w = {
            function()
                util.toggle("wrap")
            end,
            "Word Wrap",
        },
        n = {
            function()
                util.toggle("relativenumber", true)
                util.toggle("number")
            end,
            "Relative Line Numbers",
        },
        z = { "<cmd>lua require('zen-mode').toggle()<cr>", "Zen Mode" },
        Z = { "<cmd>lua require('zen-mode').reset()<cr>", "Zen Mode (Reset)" },

    },
    ["`"] = { "<cmd>NavigatorPrevious<cr>", "Switch to Other Buffer" },
    [" "] = "Find File",
    ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
    [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
    [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
    q = {
        name = "+quit/session",
        q = { "<cmd>:qa<cr>", "Quit" },
        ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
        s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
        l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
        d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
    },
    x = {
        name = "+errors",
        x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
        t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
        T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
        l = { "<cmd>lopen<cr>", "Open Location List" },
        q = { "<cmd>copen<cr>", "Open Quickfix List" },
    },
    ["?"] = {
        name = "+which-key mappings",
        ["?"] = { "<cmd>whichkey <leader><cr>", "show all <leader> mappings" },
        [" "] = { "<cmd>whichkey <cr>", "show all mappings" },
        ["n"] = { "<cmd>whichkey <leader> n<cr>", "show all <leader> mappings for normal mode" },
        ["v"] = { "<cmd>whichkey <leader> v<cr>", "show all <leader> mappings for visual mode" },
        ["i"] = { "<cmd>whichkey <leader> i<cr>", "show all <leader> mappings for insert mode" },
        --["<alt>"] = { "<cmd>whichkey <alt><cr>", "show all <alt> mappings" },
    }
}

wk.register(leader, { prefix = "<leader>" })
wk.register({ g = { name = "+goto", h = "Hop Word" }, s = "Hop Word1" })
