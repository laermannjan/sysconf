{
  programs.nixvim = {
    plugins = {
      lspkind = {
        enable = true;
        cmp.enable = true;
      };
      lsp = {
        enable = true;
        preConfig = ''
          local icons = {
              diagnostics = {
                    BoldError = "",
                    Error = "",
                    BoldWarning = "",
                    Warning = "",
                    BoldInformation = "",
                    Information = "",
                    BoldQuestion = "",
                    Question = "",
                    BoldHint = "",
                    Hint = "󰌶",
                    Debug = "",
                    Trace = "✎",
                },
            }

          local default_diagnostic_config = {
              signs = {
                  active = true,
                  values = {
                      { name = "DiagnosticSignError", text = icons.diagnostics.Error },
                      { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
                      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
                      { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
                  },
              },
              virtual_text = false,
              update_in_insert = false,
              underline = true,
              severity_sort = true,
              float = {
                  focusable = true,
                  style = "minimal",
                  border = "rounded",
                  source = "always",
                  header = "",
                  prefix = "",
              },
          }

          vim.diagnostic.config(default_diagnostic_config)
          for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
              vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
          end
        '';

        keymaps = {
          silent = true;
          diagnostic = {
            # # Navigate in diagnostics
            # "<leader>k" = "goto_prev";
            # "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "declaration";
            "<c-k>" = "signature_help";
            gr = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<leader>cr" = "rename";
            "<leader>ca" = "code_action";
          };
          extra = [
            {
              action = "vim.lsp.codelens.run";
              key = "<leader>cl";
              mode = "n";
              lua = true;
            }
          ];
        };
        servers = {
          bashls.enable = true;
          beancount.enable = true;
          gopls.enable = true;
          helm-ls.enable = true;
          jsonls.enable = true;
          marksman.enable = true;
          nil_ls.enable = true;
          lua-ls.enable = true;
          # pyright.enable = true;
          pylsp = {
            enable = true;
            settings.plugins = {
              pylsp_mypy.enabled = true;
              ruff.enabled = true;
            };
          };

          # could be alternatives to the pylsp plugin
          # ruff.enable = true;
          # ruff-lsp.enable = true;
          rust-analyzer.enable = true;
          sqls.enable = true;
          taplo.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;
        };
      };
    };
  };
}
