{ config, pkgs, ... }:
let
  ignorePatterns = ''
    !.env*
    !.github/
    !.gitignore
    !*.tfvars
    .terraform/
    .target/
    /Library/'';
in
{
  config = {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        age # Encryption
        bc # Calculator
        curl
        delta # Fancy diffs
        devenv
        difftastic # Other fancy diffs
        dig # DNS lookup
        dogdns # DNS lookup but written in rust
        du-dust # Disk usage tree (ncdu)
        dua # File sizes (du)
        duf # Basic disk information (df)
        fd # find
        ffmpeg # the OG
        htop # Show system processes
        inetutils # Includes telnet, whois
        jless # JSON viewer
        jo # JSON output
        jq # JSON manipulation
        killall # Force quit
        lf # File viewer
        lz4 # archive lib
        openssh
        p7zip
        pandoc # document conversion
        qrencode # Generate qr codes
        ripgrep # grep
        rsync # Copy folders
        sd # sed
        ssh-copy-id
        tealdeer # Cheatsheets
        tree # View directory hierarchy
        unzip # Extract zips
        vimv-rs # Batch rename files
        xz # archive lib -- almost wrecked the world! (xz backdoor 2024; https://www.nytimes.com/2024/04/03/technology/prevent-cyberattack-linux.html)
        zstd # archive
      ];

      programs.zoxide.enable = true; # Shortcut jump command

      home.file = {
        ".digrc".text = "+noall +answer"; # Cleaner dig commands
      };

      xdg.configFile."fd/ignore".text = ignorePatterns;

      programs.awscli = {
        enable = true; # creds managed with 1password-cli plugin
        settings = {
          "default" = {
            region = "eu-central-1";
          };
        };
      };

      programs.bat = {
        enable = true; # cat replacement
        config = {
          italic-text = "always";
          # theme = config.theme.colors.batTheme;
          pager = "less -R"; # Don't auto-exit if one screen
        };
      };

      programs.eza = {
        # used to be exa
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
          "--group"
          "--git"
        ];
      };

      programs = {
        btop = {
          enable = true;
        };
      };

      programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
          tmux.enableShellIntegration = true;
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          # cattpuccin_mocha blue accent
          gui.theme = {
            activeBorderColor = [
              "#89b4fa"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            selectedRangeBgColor = [ "#313244" ];
            cherryPiCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#89b4fa" ];
            unstagedChansColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
          git.autoFetch = true;
        };
      };

      programs.fish.functions = {
        ping = {
          description = "Improved ping";
          argumentNames = "target";
          body = "${pkgs.prettyping}/bin/prettyping --nolegend $target";
        };
      };
    };
  };
}
