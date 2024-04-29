{ config, lib, ... }:
{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps =
      let
        normal =
          lib.mapAttrsToList
            (key: action: {
              mode = "n";
              inherit action key;
            })
            {
              # center search results
              n = "nzzzv";
              N = "Nzzzv";
              "*" = "*zzzv";
              "#" = "#zzzv";
              "g*" = "g*zzzv";
              "g#" = "g#zzzv";

              # move current line up/down
              # M = Alt key
              "<M-k>" = ":move-2<CR>";
              "<M-j>" = ":move+<CR>";
            };
        visual =
          lib.mapAttrsToList
            (key: action: {
              mode = "v";
              inherit action key;
            })
            {
              # better indenting
              ">" = ">gv";
              "<" = "<gv";

              "p" = "\"_dP";

              # move selected line / block of text in visual mode
              "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";
            };
        insert =
          lib.mapAttrsToList
            (key: action: {
              mode = "i";
              inherit action key;
            })
            {
              # add undo break points
              "," = "<c-g>u,";
              "." = "<c-g>u.";
              ";" = "<c-g>u;";
            };

        misc = [
          {
            key = "[d";
            action = "vim.diagnostic.goto_prev";
            mode = "n";
            lua = true;
          }
          {
            key = "]d";
            action = "vim.diagnostic.goto_next";
            mode = "n";
            lua = true;
          }
          {
            key = "gl";
            action = "vim.diagnostic.open_float";
            mode = "n";
            lua = true;
          }
          {
            key = "H";
            action = "^";
            mode = [
              "n"
              "x"
              "o"
            ];
          }
          # Press 'H', 'L' to jump to start/end of a line (first/last character)
          {

            key = "L";
            action = "g_"; # like $, but doesn't include the return character at EOL
            mode = [
              "n"
              "x"
              "o"
            ];
          }
          {
            key = "<space>";
            action = "<nop>";
            mode = [
              "n"
              "v"
            ];
          }
          {
            # Esc to clear search results
            key = "<ESC>";
            action = ":noh<cr>";
            mode = [
              "n"
              "v"
            ];
          }
        ];
      in
      config.nixvim.helpers.keymaps.mkKeymaps { options.silent = true; } (
        normal ++ visual ++ insert ++ misc
      );
  };
}
