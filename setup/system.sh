#!/usr/bin/env bash
# macOS system preferences
# Sourced by sysconf.sh (helpers/platform already loaded)

is_mac || return 0

log "Configuring macOS system preferences"

# --- Keyboard & input ---
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                          # full keyboard access for all controls
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                # key repeat instead of press-and-hold
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1              # tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
log_ok "Keyboard & input"

# --- UI ---
defaults write NSGlobalDomain _HIHideMenuBar -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSStatusItemSelectionPadding -int 6
defaults write NSGlobalDomain NSStatusItemSpacing -int 6
log_ok "UI preferences"

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock mouse-over-hilite-stack -bool true
defaults write com.apple.dock mineffect -string "genie"
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 44
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 48
log_ok "Dock"

# --- Finder ---
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"              # column view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"              # search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
chflags nohidden ~/Library
log_ok "Finder"

# --- Security & privacy ---
defaults write com.apple.LaunchServices LSQuarantine -bool false                  # no "are you sure" dialog
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Use sudo_local (survives macOS updates, available since Sonoma)
if [[ -f /etc/pam.d/sudo_local ]]; then
    if ! grep -q pam_tid.so /etc/pam.d/sudo_local 2>/dev/null; then
        echo "auth       sufficient     pam_tid.so" | sudo tee -a /etc/pam.d/sudo_local >/dev/null
    fi
elif ! grep -q pam_tid.so /etc/pam.d/sudo 2>/dev/null; then
    sudo sed -i '' '1s/^/auth       sufficient     pam_tid.so\n/' /etc/pam.d/sudo
fi
log_ok "Security & privacy"

# --- Misc ---
# shellcheck disable=SC2088 # macOS defaults handles ~ expansion
defaults write com.apple.screencapture location -string "~/Screenshots"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
sudo chflags nohidden /Volumes
log_ok "Misc"
