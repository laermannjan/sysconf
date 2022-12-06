local M = {}

local ok, whichkey = pcall(require, "which-key")
if not ok then
   require("utils").error("could not require which-key.\nleader mappings will not work", "which-key setup")
   return
end

local conf = {
   window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
   },
}
whichkey.setup(conf)


local ok, legendary = pcall(require, "legendary.integrations.which-key")
if not ok then
   require("utils").error("could not require legendary.\nleader mappings will not work", "which-key setup")
   return
end

local opts = {
   mode = "n", -- Normal mode
   prefix = "<leader>",
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true, -- use `silent` when creating keymaps
   noremap = true, -- use `noremap` when creating keymaps
   nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
   mode = "v", -- Visual mode
   prefix = "<leader>",
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true, -- use `silent` when creating keymaps
   noremap = true, -- use `noremap` when creating keymaps
   nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
   local keymap = {
      ["q"] = { "<cmd>lua require('utils').quit()<CR>", "Quit" },
      ["/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "find in buffer" },

      w = {
         name = "window",
         h = { "<C-w>h", "focus left" },
         j = { "<C-w>j", "focus below" },
         k = { "<C-w>k", "focus above" },
         l = { "<C-w>l", "focus right" },
         v = { "<cmd>vsplit<cr>", "split right" },
         V = { "<cmd>vsplit<cr>", "split below" },
         q = { "<cmd>close<cr>", "close window" },
      },

      c = {
         name = "Code",
         a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
         d = { "<cmd>TroubleToggle document_diagnostics<cr>", "diagnostics" },
         D = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics" },
         t = { "<cmd>TroubleToggle todo<cr>", "todos" },
         q = { "<cmd>TroubleToggle lsp_references<cr>", "open lsp reference" },
         S = { "<cmd>SidebarNvimToggle<CR>", "sidebar" },
         s = { "<cmd>Telescope aerial<cr>", "symbols" },
         o = { "<cmd>AerialToggle<cr>", "outline" }
      },

      d = {
         name = "Debug",
      },

      r = {
         name = "refactor",
         r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" }
      },

      g = {
         name = "Git",
         g = { "<cmd>lua require('utils.term').git_client_toggle()<CR>", "lazygit" },
         s = { "<cmd>lua require('neogit').open()<CR>", "neogit status" },
         c = { "<cmd>lua require('utils.term').git_commit_toggle()<CR>", "Conventional Commits" },
         h = { name = "hunk" },
         -- b = { "<Cmd>Gitsigns blame_line<CR>", "Toggle Git Blame" },
      },

      o = {
         name = "Org",
      },

      t = {
         name = "Test",
         a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
         f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
         F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Debug File" },
         l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
         L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
         n = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
         N = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
         o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
         S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
         s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
         p = { "<Plug>PlenaryTestFile", "PlenaryTestFile" },
         v = { "<cmd>TestVisit<cr>", "Visit" },
         x = { "<cmd>TestSuite<cr>", "Suite" },
      },

      f = {
         name = "files",
         f = { "<cmd>lua require('utils.finder').find_files()<cr>", "find file" },
         p = { "<cmd>Telescope file_browser<cr>", "browse from project root" },
         ['.'] = { "<cmd>lua require('telescope').extensions.file_browser.file_browser({path=require('telescope.utils').buffer_dir()})<cr>",
            "browse from here" },
         d = { "<cmd>lua require('utils.finder').find_files({cwd='~/code/lj/dotfiles/'})<cr>",
            "find in dotfiles" },
         c = { "<cmd>lua require('telescope.builtin').find_files({cwd='~/.config/nvim/'})<cr>",
            "find in nvim config" },
         z = { "<cmd>lua require('telescope').extensions.zoxide.list()<CR>", "zoxide" },
         e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
         ['/'] = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "grep" },
         s = { "<cmd>w!<CR>", "Save" },
      },

      z = {
         name = "System",
         c = { "<cmd>Telescope neoclip<cr>", "Clipboard" },
         r = { "<cmd>lua require('nabla').popup()<CR>", "Render Latex under point" },
         R = { "<cmd>lua require('nabla').toggle_virt()<CR>", "Render Latex in buffer" },
         p = { "<cmd>PackerProfile<cr>", "packer profile" },
         s = { "<cmd>PackerSync<cr>", "packer sync" },
         S = { "<cmd>PackerStatus<cr>", "packer status" },
         u = { "<cmd>PackerUpdate<cr>", "packer update" },
         d = { "<cmd>DiffviewOpen<cr>", "Diff View Open" },
         D = { "<cmd>DiffviewClose<cr>", "Diff View Close" },
         z = {
            name = "Zen",
            t = { "<cmd>Twilight<cr>", "Twilight" },
         }
      }
   }

   whichkey.register(keymap, opts)
   legendary.bind_whichkey(keymap, opts, false)
end

local function visual_keymap()
   local keymap = {
      g = {
         name = "Git",
         y = {
            "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>",
            "Link",
         },
      },

      r = {
         name = "Refactor",
         f = { [[<cmd>lua require('refactoring').refactor('Extract Function')<cr>]], "Extract Function" },
         F = {
            [[ <cmd>lua require('refactoring').refactor('Extract Function to File')<cr>]],
            "Extract Function to File",
         },
         v = { [[<cmd>lua require('refactoring').refactor('Extract Variable')<cr>]], "Extract Variable" },
         i = { [[<cmd>lua require('refactoring').refactor('Inline Variable')<cr>]], "Inline Variable" },
         r = { [[<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>]], "Refactor" },
         d = { [[<cmd>lua require('refactoring').debug.print_var({})<cr>]], "Debug Print Var" },
      },
   }

   whichkey.register(keymap, v_opts)
   legendary.bind_whichkey(keymap, opts, false)
end

local function code_keymap()
   vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
         vim.schedule(CodeRunner)
      end,
   })

   function CodeRunner()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      local fname = vim.fn.expand "%:p:t"
      local keymap_c = {} -- normal key map
      local keymap_c_v = {} -- visual key map

      if ft == "python" then
         keymap_c = {
            name = "Code",
            i = { "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>", "Inspect" },
            r = {
               "<cmd>update<cr><cmd>lua require('utils.term').open_term([[python3 ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1), {direction = 'float'})<cr>",
               "run file",
            },
            R = { "<cmd>update<cr><cmd>lua vim.ui.input({prompt = 'args: '}, function(input) require('utils.term').open_term([[python3 ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1) .. ' ' .. input, {direction = 'float'})end)<cr>",
               "run file with args" },
            m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
         }
      elseif ft == "lua" then
         keymap_c = {
            name = "Code",
            r = { "<cmd>luafile %<cr>", "run file" },
         }
      elseif ft == "rust" then
         keymap_c = {
            name = "Code",
            r = { "<cmd>execute 'Cargo run' | startinsert<cr>", "run file" },
            D = { "<cmd>RustDebuggables<cr>", "Debuggables" },
            h = { "<cmd>RustHoverActions<cr>", "Hover Actions" },
            R = { "<cmd>RustRunnables<cr>", "Runnables" },
         }
      elseif ft == "go" then
         keymap_c = {
            name = "Code",
            r = { "<cmd>GoRun<cr>", "run file" },
         }
      elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
         keymap_c = {
            name = "Code",
            o = { "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports" },
            r = { "<cmd>TypescriptRenameFile<cr>", "Rename File" },
            i = { "<cmd>TypescriptAddMissingImports<cr>", "Import Missing" },
            F = { "<cmd>TypescriptFixAll<cr>", "Fix All" },
            u = { "<cmd>TypescriptRemoveUnused<cr>", "Remove Unused" },
            R = { "<cmd>lua require('config.test').javascript_runner()<cr>", "Choose Test Runner" },
            -- s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" },
            -- t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" },
         }
      elseif ft == "java" then
         keymap_c = {
            name = "Code",
            o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
            v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
            c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
            t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
            n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
         }
         keymap_c_v = {
            name = "Code",
            v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
            c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
            m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
         }
      end

      if fname == "package.json" then
         keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
         keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
         -- keymap_c.s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" }
         -- keymap_c.t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" }
      end

      if fname == "Cargo.toml" then
         keymap_c.u = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade All Crates" }
      end

      if next(keymap_c) ~= nil then
         local k = { c = keymap_c }
         local o = { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
         whichkey.register(k, o)
         legendary.bind_whichkey(k, o, false)
      end

      if next(keymap_c_v) ~= nil then
         local k = { c = keymap_c_v }
         local o = { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
         whichkey.register(k, o)
         legendary.bind_whichkey(k, o, false)
      end

   end
end

M.setup = function()
   normal_keymap()
   visual_keymap()
   code_keymap()
end

return M
