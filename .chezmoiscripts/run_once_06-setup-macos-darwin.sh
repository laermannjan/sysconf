#!/bin/bash
set -euo pipefail

# ============================================================================
# NSGlobalDomain
# ============================================================================

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                       # Full keyboard access for all controls
defaults write NSGlobalDomain _HIHideMenuBar -bool false                       # Only hide menu bar in fullscreen
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true     # Expand save panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true        # Expand print panel by default
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false              # Key repeat instead of press-and-hold
defaults write NSGlobalDomain KeyRepeat -int 1                                 # Fast key repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 15                         # Short delay before key repeat
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false     # Save to local disk, not iCloud
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false      # Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false    # Disable smart dashes
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # Disable auto-period
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false   # Disable smart quotes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # Disable spellcheck
defaults write NSGlobalDomain NSStatusItemSelectionPadding -int 6              # Reduce menu bar padding
defaults write NSGlobalDomain NSStatusItemSpacing -int 6                       # Reduce menu bar padding

# ============================================================================
# Dock
# ============================================================================

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

# ============================================================================
# Finder
# ============================================================================

defaults write com.apple.finder FXPreferredViewStyle -string "clmv"            # Column view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"            # Search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false     # No extension change warning
defaults write com.apple.finder QuitMenuItem -bool true                        # Allow quitting Finder
defaults write com.apple.finder ShowPathbar -bool true                         # Show path breadcrumbs
defaults write com.apple.finder AppleShowAllExtensions -bool true              # Show all file extensions
defaults write com.apple.finder ShowStatusBar -bool true                       # Show status bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true             # POSIX path in title
defaults write com.apple.finder WarnOnEmptyTrash -bool false                   # No empty trash warning
defaults write com.apple.finder _FXSortFoldersFirst -bool true                 # Folders on top
defaults write com.apple.finder NewWindowTarget -string "PfLo"                 # New window opens home
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"  # New window opens home

# ============================================================================
# Other settings
# ============================================================================

defaults write com.apple.LaunchServices LSQuarantine -bool false                                        # No "are you sure" dialog
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1                       # Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1         # Three-finger drag
defaults write com.apple.screencapture location -string "~/Screenshots"                                  # Screenshot location
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true                             # No .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true                                 # No .DS_Store on USB
defaults write com.apple.screensaver askForPassword -int 1                                               # Password after screensaver
defaults write com.apple.screensaver askForPasswordDelay -int 0                                          # Immediately

# ============================================================================
# TouchID for sudo
# ============================================================================

if ! grep -q pam_tid.so /etc/pam.d/sudo; then
    sudo sed -i '' '1s/^/auth       sufficient     pam_tid.so\n/' /etc/pam.d/sudo
fi

# ============================================================================
# Show hidden folders
# ============================================================================

chflags nohidden ~/Library
sudo chflags nohidden /Volumes

# ============================================================================
# Finder snap-to-grid
# ============================================================================

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# ============================================================================
# Dock items (via dockutil)
# ============================================================================

# Remove default items
for app in Launchpad Safari Messages Maps Photos FaceTime Contacts Reminders Notes Calendar TV Podcasts "App Store"; do
    dockutil --remove "$app" --no-restart 2>/dev/null || true
done

# Add desired items
dockutil --add "/System/Library/CoreServices/Finder.app" --position 1 --no-restart
dockutil --add "/Applications/Arc.app" --position 2 --no-restart
dockutil --add "/Applications/Firefox Developer Edition.app" --position 3 --no-restart
dockutil --add "/Applications/WezTerm.app" --position 4 --no-restart
dockutil --add "/Applications/Slack.app" --position 5 --no-restart
dockutil --add "/Applications/Notion Calendar.app" --position 6 --no-restart
dockutil --add "/System/Applications/Mail.app" --position 7 --no-restart
dockutil --add "/Applications/1Password.app" --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart

killall Dock
