{ ... }:
{
  programs.nixvim.plugins = {
    trouble = {
        enable = true;
        settings.use_diagnostic_signs = true;
    };

    telescope.settings = {
      defaults.mappings = {
        i = {
          "<C-t>".__raw = "function (...) return require('trouble.providers.telescope').open_with_trouble(...) end";
          "<A-i>".__raw = ''
            function()
                local action_state = require "telescope.actions.state"
                local line = action_state.get_current_line()
                require("telescope.builtin").find_files {
                    no_ignore = true,
                    no_ignore_parents = true,
                    default_text = line,
                }
            end

          '';
          "<A-h>".__raw = ''
            function()
                local action_state = require "telescope.actions.state"
                local line = action_state.get_current_line()
                require("telescope.builtin").find_files { hidden = true, default_text = line }
            end
          '';
        };
        n = {
          "<C-t>".__raw = "function (...) return require('trouble.providers.telescope').open_with_trouble(...) end";
        };
      };
    };
  };
}
