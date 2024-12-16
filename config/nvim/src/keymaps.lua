-- Helper function
local keymap = function(mode, keys, cmd, opts)
    opts = opts or {}
    if opts.silent == nil then opts.silent = true end
    vim.keymap.set(mode, keys, cmd, opts)
end

-- Create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end
local vmap_leader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set('v', '<Leader>' .. suffix, rhs, opts)
end

local nmap_localleader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set('n', '<LocalLeader>' .. suffix, rhs, opts)
end
local xmap_localleader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set('x', '<LocalLeader>' .. suffix, rhs, opts)
end

-- Remove search highlights on <esc>
-- keymap({"n", "v"}, "<esc>", "<cmd>noh<cr><esc>", { silent = true })

-- Stop highlighting of search results. NOTE: this can be done with default
-- `<C-l>` but this solution deliberately uses `:` instead of `<Cmd>` to go
-- into Command mode and back which updates 'mini.map'.
keymap('n', [[\h]], ':let v:hlsearch = 1 - v:hlsearch<CR>', { desc = 'Toggle hlsearch' })

-- Better command history navigation
keymap('c', '<C-p>', '<Up>', { silent = false })
keymap('c', '<C-n>', '<Down>', { silent = false })

keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({severity = "ERROR"})<cr>')
keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next({severity = "ERROR"})<cr>')

_G.Config.leader_group_clues = {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
    { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    -- { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>L', desc = '+Lua' },
    { mode = 'n', keys = '<Leader>o', desc = '+Other' },
    { mode = 'n', keys = '<Leader>t', desc = '+Tests' },
    { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

    -- { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
    -- { mode = 'x', keys = '<Leader>r', desc = '+R' },
}

local function get_args()
    local input = vim.fn.input('Run with args (space separated, use `=`): ')
    local args = vim.split(input, '%s+', { trimempty = true })
    return args
end

-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete!')
nmap_leader('bs', '<Cmd>lua Config.new_scratch_buffer()<CR>', 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- d is for 'debug'
nmap_leader('dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Breakpoint Condition')
nmap_leader('db', function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint')
nmap_leader('dc', function() require('dap').continue() end, 'Run/Continue')
nmap_leader('da', function() require('dap').continue({ before = get_args }) end, 'Run with Args')
nmap_leader('dC', function() require('dap').run_to_cursor() end, 'Run to Cursor')
nmap_leader('dg', function() require('dap').goto_() end, 'Go to Line (No Execute)')
nmap_leader('di', function() require('dap').step_into() end, 'Step Into')
nmap_leader('dj', function() require('dap').down() end, 'Down')
nmap_leader('dk', function() require('dap').up() end, 'Up')
nmap_leader('dl', function() require('dap').run_last() end, 'Run Last')
nmap_leader('do', function() require('dap').step_out() end, 'Step Out')
nmap_leader('dO', function() require('dap').step_over() end, 'Step Over')
nmap_leader('dp', function() require('dap').pause() end, 'Pause')
nmap_leader('dr', function() require('dap').repl.toggle() end, 'Toggle REPL')
nmap_leader('ds', function() require('dap').session() end, 'Session')
nmap_leader('dt', function() require('dap').terminate() end, 'Terminate')
nmap_leader('dw', function() require('dap.ui.widgets').hover() end, 'Widgets')
nmap_leader('du', function() require('dapui').toggle({}) end, 'Dap UI')
nmap_leader('de', function() require('dapui').eval() end, 'Eval')
vmap_leader('de', function() require('dapui').eval() end, 'Eval')

-- e is for 'explore' and 'edit'
nmap_leader('ec', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<CR>', 'Config')
nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'File directory')
nmap_leader('em', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/start/mini.nvim")<CR>', 'Mini.nvim directory')
nmap_leader('ep', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/opt")<CR>', 'Plugins directory')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>', 'Quickfix')

-- f is for 'fuzzy find'
nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (current)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (current)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('/', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (current)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (current)')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols buffer (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace (LSP)')
nmap_leader('fv', '<Cmd>Pick visit_paths filter="tagged"<CR>', 'Visit paths (tagged)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')

-- g is for git
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
-- nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>', 'Git tab')
nmap_leader('gg', function() require('snacks').lazygit() end, 'LazyGit')
nmap_leader('gf', function() require('snacks').lazygit.log_file() end, 'LazyGit Current File History')
-- nmap_leader('gl', '<Cmd>Git log --oneline<CR>', 'Log')
nmap_leader('gl', function() require('snacks').lazygit.log() end, 'LazyGit Log (cwd)')
nmap_leader('gL', '<Cmd>Git log --oneline --follow -- %<CR>', 'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

-- L is for 'Lua'
nmap_leader('Lc', '<Cmd>lua Config.log_clear()<CR>', 'Clear log')
nmap_leader('LL', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', 'Source buffer')
nmap_leader('Ls', '<Cmd>lua Config.log_print()<CR>', 'Show log')
nmap_leader('Lx', '<Cmd>lua Config.execute_lua_line()<CR>', 'Execute `lua` line')

-- t is for test
-- nmap_leader('tf', '<cmd>Neotest run vim.fn.expand("%")<cr>', 'Run file')
-- nmap_leader('tt', '<cmd>Neotest run<cr>', 'Run nearest test')
-- nmap_leader('ta', '<cmd>Neotest run suite=true<cr>', 'Run all tests')
-- nmap_leader('tf', function() require('neotest').run.run(vim.fn.expand('%')) end, 'Run file')
-- nmap_leader('tt', function() require('neotest').run.run() end, 'Run nearest')
-- nmap_leader('ta', function() require('neotest').run.run({ suite = true }) end, 'Run all tests')
-- nmap_leader('tr', function() require('neotest').run.run({ vim.fn.getcwd(), extra_args = args }) end, 'Run tests in project (with args)')

nmap_leader('tf', function() require('neotest').run.run(vim.fn.expand('%')) end, 'Run File (Neotest)')
nmap_leader('ta', function() require('neotest').run.run(vim.uv.cwd()) end, 'Run All Test Files (Neotest)')
nmap_leader('tt', function() require('neotest').run.run() end, 'Run Nearest (Neotest)')
nmap_leader('td', function() require('neotest').run.run({ strategy = 'dap' }) end, 'Debug Nearest (Neotest + DAP)')
nmap_leader('tT', function() require('neotest').run.run({ vim.uv.cwd(), extra_args = get_args() }) end, 'Run with args (Neotest)')
nmap_leader('tl', function() require('neotest').run.run_last() end, 'Run Last (Neotest)')
nmap_leader('ts', function() require('neotest').summary.toggle() end, 'Toggle Summary (Neotest)')
nmap_leader('to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, 'Show Output (Neotest)')
nmap_leader('tO', function() require('neotest').output_panel.toggle() end, 'Toggle Output Panel (Neotest)')
nmap_leader('tS', function() require('neotest').run.stop() end, 'Stop (Neotest)')
nmap_leader('tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, 'Toggle Watch (Neotest)')

nmap_leader('vv', '<cmd>lua MiniVisits.add_label("tagged")<cr>', 'Add "tagged" label')
nmap_leader('vd', '<cmd>lua MiniVisits.remove_label("tagged")<cr>', 'Remove "tagged" label')
nmap_leader('vV', '<cmd>lua MiniVisits.add_label()<cr>', 'Add label')
nmap_leader('vD', '<cmd>lua MiniVisits.remove_label()<cr>', 'Remove label')

-- o is for 'other'
local trailspace_toggle_command = '<Cmd>lua vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable<CR>'
nmap_leader('oC', '<cmd>lua MiniCursorword.toggle()<cr>', 'Cursor word hl toggle')
nmap_leader('od', '<cmd>Neogen<cr>', 'Generate documentation')
nmap_leader('oh', '<cmd>normal gxiagxila<cr>', 'Move arg left') -- NOTE: depends on mini.operators to exchange text regions
nmap_leader('ol', '<cmd>normal gxiagxina<cr>', 'Move arg left') -- NOTE: depends on mini.operators to exchange text regions
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>', 'Trim trailspace')
nmap_leader('oT', trailspace_toggle_command, 'Trailspace hl toggle')

nmap_localleader('a', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action')
nmap_localleader('d', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Symbol Definition')
nmap_localleader(',', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename Symbol')
nmap_localleader('r', '<cmd>lua vim.lsp.buf.references()<cr>', 'Symbol references')
nmap_localleader('h', '<cmd>normal gxiagxila<cr>', 'Move arg left') -- NOTE: depends on mini.operators to exchange text regions
nmap_localleader('l', '<cmd>normal gxiagxina<cr>', 'Move arg left') -- NOTE: depends on mini.operators to exchange text regions
