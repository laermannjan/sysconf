{
  programs.nixvim = {
    plugins = {
      lspkind = {
        enable = true;
        cmp.enable = true;
      };
      lsp = {
        enable = true;

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
