{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    gitName = lib.mkOption {
      type = lib.types.str;
      description = "Name to use for git commits";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email to use for git commits";
    };
  };

  config = {
    home-manager.users.root.programs.git = {
      enable = true;
      extraConfig.safe.directory = config.sysconfPath;
    };

    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        userName = config.gitName;
        userEmail = config.gitEmail;
        extraConfig = {
          init.defaultBranch = "main";
          init.templateDir = "~/.git-template";
          safe = {
            directory = config.sysconfPath;
          };
          color.ui = true;
          pull.ff = "only";
          push = {
            default = "current";
            autoSetupRemote = true;
            useForceIfIncludes = true;
            followtags = true;
          };
          rebase = {
            updateRefs = true;
          };
          gpg = {
            format = "ssh";
          };
          help.autocorrect = "1";
          log.date = "iso";
        };
        delta = {
          enable = true;
          options = {
            navigate = true;
          };
        };
        ignores = [
          # IntelliJ
          ".idea/"

          # Vim/Emacs
          "*~"
          ".*.swp"

          # Mac
          ".DS_Store"
          ".fseventsd"
          ".Spotlight-V100"
          ".TemporaryItems"
          ".Trashes"

          # Helix
          ".helix/"

          # VSCode Workspace Folder
          ".vscode/"

          # Rust
          "debug/"
          "target/"

          # Python
          "*.pyc"
          "*.egg"
          "*.out"
          "venv/"
          ".venv/"
          "**/**/__pycache__/"
          ".mypy_cache/"

          # Nix
          "result"
          "result-*"

          # direnv
          ".direnv"
          ".envrc"

          # NodeJS/Web dev
          ".env/"
          "node_modules"
          ".sass-cache"

          # Devenv
          ".devenv*"
          "devenv.local.nix"
          ".devenv"

          # direnv
          ".direnv"

          # pre-commit
          ".pre-commit-config.yaml"
        ];
        includes = [
          {
            path = "~/.config/git/personal";
            condition = "gitdir:~/dev/personal/";
          }
        ];
      };

      # Personal git config
      # TODO: fix with variables
      xdg.configFile."git/personal".text =
        ''
          [user]
              name = "${config.fullName}"
              email = "hello@mikgard.dev"
              signingkey = ~/.ssh/id_ed25519.personal
          [commit]
              gpgsign = true
          [tag]
              gpgsign = true
        ''
        + lib.optionalString (config._1password.enableSshAgent && pkgs.stdenv.isDarwin) ''
          [gpg "ssh"]
              program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        '';
    };
  };
}
