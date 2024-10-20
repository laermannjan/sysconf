{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services.nix-daemon.enable = true;

    # This setting only applies to Darwin, different on NixOS
    nix.gc.interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    };

    environment.shells = [
      pkgs.zsh
      pkgs.fish
    ];

    security.pam.enableSudoTouchIdAuth = true;

    system = {

      stateVersion = 5;

      keyboard = {
        remapCapsLockToControl = true;
        enableKeyMapping = true; # Allows for skhd
      };

      defaults = {
        NSGlobalDomain = {
          # Set to dark mode
          # AppleInterfaceStyle = "Dark";

          # Don't change from dark to light automatically
          # AppleInterfaceSwitchesAutomatically = false;

          # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
          AppleKeyboardUIMode = 3;

          # Only hide menu bar in fullscreen
          _HIHideMenuBar = false;

          # Expand save panel by default
          NSNavPanelExpandedStateForSaveMode = true;

          # Expand print panel by default
          PMPrintingExpandedStateForPrint = true;

          # Replace press-and-hold with key repeat
          ApplePressAndHoldEnabled = false;

          # Set a fast key repeat rate
          KeyRepeat = 1;

          # Shorten delay before key repeat begins
          InitialKeyRepeat = 15;

          # Save to local disk by default, not iCloud
          NSDocumentSaveNewDocumentsToCloud = false;

          # Disable autocorrect capitalization
          NSAutomaticCapitalizationEnabled = false;

          # Disable autocorrect smart dashes
          NSAutomaticDashSubstitutionEnabled = false;

          # Disable autocorrect adding periods
          NSAutomaticPeriodSubstitutionEnabled = false;

          # Disable autocorrect smart quotation marks
          NSAutomaticQuoteSubstitutionEnabled = false;

          # Disable autocorrect spellcheck
          NSAutomaticSpellingCorrectionEnabled = false;
        };

        dock = {
          # Automatically show and hide the dock
          autohide = true;

          # Add translucency in dock for hidden applications
          showhidden = true;

          # Enable spring loading on all dock items
          enable-spring-load-actions-on-all-items = true;

          # Highlight hover effect in dock stack grid view
          mouse-over-hilite-stack = true;

          mineffect = "genie";
          orientation = "bottom";
          show-recents = false;
          tilesize = 44;

          show-process-indicators = true;

          persistent-apps = [
            "${pkgs.firefox-devedition-bin}/Applications/Firefox Developer Edition.app"
            "${pkgs.wezterm}/Applications/WezTerm.app"
            "${pkgs.slack}/Applications/Slack.app"
            "/System/Applications/Calendar.app"
            "${pkgs.discord}/Applications/Discord.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/Applications/1Password.app"
            "/System/Applications/System Settings.app"
          ];
        };

        finder = {
          # Default Finder window set to column view
          FXPreferredViewStyle = "clmv";

          # Finder search in current folder by default
          FXDefaultSearchScope = "SCcf";

          # Disable warning when changing file extension
          FXEnableExtensionChangeWarning = false;

          # Allow quitting of Finder application
          QuitMenuItem = true;

          # Show the path breadcrumbs
          ShowPathbar = true;

          # Show file extensions of all files
          AppleShowAllExtensions = true;

          # Show status bar at bottom of finder windows with item/disk space stats.
          ShowStatusBar = true;

          # show the full POSIX filepath in the window title
          _FXShowPosixPathInTitle = true;
        };

        # Disable "Are you sure you want to open" dialog
        LaunchServices.LSQuarantine = false;

        # Enable trackpad tap to click
        trackpad.Clicking = true;

        # Enable item dragging with three finger swipe gestures
        trackpad.TrackpadThreeFingerDrag = true;

        # Where to save screenshots
        screencapture.location = "~/Downloads";

        CustomUserPreferences = {
          "com.apple.symbolichotkeys" = {
            AppleSymbolicHotKeys = {
              # Key 27 is for "Move Focus to Next Window (cmd+`)"
              "27" = {
                enabled = false;
              };
            };
          };
          # Disable disk image verification
          "com.apple.frameworks.diskimages" = {
            skip-verify = true;
            skip-verify-locked = true;
            skip-verify-remote = true;
          };
          # Avoid creating .DS_Store files on network or USB volumes
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.dock" = {
            magnification = true;
            largesize = 48;
          };
          # Require password immediately after screen saver begins
          "com.apple.screensaver" = {
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.finder" = {
            # Disable the warning before emptying the Trash
            WarnOnEmptyTrash = false;

            # Finder search in current folder by default
            FXDefaultSearchScope = "SCcf";

            # Default Finder window set to column view
            FXPreferredViewStyle = "clmv";
          };
          "leits.MeetingBar" = {
            eventTimeFormat = ''"show"'';
            eventTitleFormat = ''"none"'';
            eventTitleIconFormat = ''"iconCalendar"'';
            slackBrowser = ''{"deletable":true,"arguments":"","name":"Slack","path":""}'';
            zoomBrowser = ''{"deletable":true,"arguments":"","name":"Zoom","path":""}'';
            KeyboardShortcuts_joinEventShortcut = ''{"carbonModifiers":6400,"carbonKeyCode":38}'';
            timeFormat = ''"24-hour"'';
          };
        };

        CustomSystemPreferences = { };
      };

      # Settings that don't have an option in nix-darwin
      activationScripts.postActivation.text = ''
        echo "Allow apps from anywhere"
        SPCTL=$(spctl --status)
        if ! [ "$SPCTL" = "assessments disabled" ]; then
            sudo spctl --master-disable
        fi
      '';

      # User-level settings
      activationScripts.postUserActivation.text = ''
        echo "Show the ~/Library folder"
        chflags nohidden ~/Library
        echo "Show the /Volumes folder"
        sudo chflags nohidden /Volumes

        echo "Reduce Menu Bar padding"
        defaults write -globalDomain NSStatusItemSelectionPadding -int 6
        defaults write -globalDomain NSStatusItemSpacing -int 6

        echo "Enable snap-to-grid for icons on the desktop and in other icon views"
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

        echo "Keep folders on top when sorting by name"
        defaults write com.apple.finder _FXSortFoldersFirst -bool true

        echo "New Finder window will open in home directory"
        defaults write com.apple.finder NewWindowTarget -string "PfLo"
        defaults write com.apple.finder NewWindowTargetPath -string "file://${config.homePath}/"

        # Avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

      '';
    };
  };
}
