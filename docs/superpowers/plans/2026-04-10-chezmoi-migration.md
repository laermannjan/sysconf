# Chezmoi Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace ansible with chezmoi for managing personal system configuration, using symlink mode to preserve edit-in-place workflow.

**Architecture:** The git repo becomes the chezmoi source directory. Config files move from `config/` to `dot_config/` (chezmoi naming). Shell scripts with `run_once_`/`run_onchange_` prefixes replace ansible roles. age encryption replaces ansible-vault. Platform-specific files use name suffixes filtered by `.chezmoiignore` glob patterns.

**Tech Stack:** chezmoi, age, bash, Homebrew/dnf, dockutil

**Spec:** `docs/superpowers/specs/2026-04-09-chezmoi-migration-design.md`

---

## File structure

**Create:**
- `.chezmoi.toml.tmpl` - chezmoi config (symlink mode, age encryption)
- `.chezmoiignore` - platform filtering globs
- `key.txt.age` - passphrase-protected age private key
- `dot_ssh/encrypted_private_config.age` - SSH config re-encrypted with age
- `fonts/fonts.tar.xz.age` - font archive re-encrypted with age
- `run_onchange_before_00-decrypt-age-key.sh.tmpl` - decrypt age key on first run
- `run_once_before_01-install-homebrew.sh` - install Homebrew/Linuxbrew
- `run_onchange_02-install-packages-darwin.sh` - macOS packages
- `run_onchange_02-install-packages-fedora.sh` - Fedora packages
- `run_once_before_03-setup-shell.sh` - fish shell setup
- `run_once_04-setup-ssh.sh` - SSH key generation + forge upload
- `run_once_05-setup-languages.sh` - rustup, uv, node
- `run_once_06-setup-macos-darwin.sh` - macOS defaults + Dock
- `run_once_07-install-fonts.sh` - extract font archive

**Move (rename):**
- `config/*` -> `dot_config/*`

**Delete:**
- `ansible/` (entire directory)
- `ansible.cfg`
- `config/` (after move to `dot_config/`)

---

### Task 1: Create branch and install chezmoi

- [ ] **Step 1: Create feature branch**

```bash
git checkout -b chezmoi-migration
```

- [ ] **Step 2: Install chezmoi locally**

```bash
brew install chezmoi
```

- [ ] **Step 3: Verify chezmoi is available**

```bash
chezmoi --version
```

- [ ] **Step 4: Commit** (nothing to commit yet, just setup)

---

### Task 2: Set up age encryption

This must happen first because later tasks depend on age being configured to encrypt the SSH config and font archive.

- [ ] **Step 1: Generate age keypair and encrypt private key with passphrase**

```bash
cd ~/sysconf
age-keygen 2>&1 | tee /dev/stderr | age -p -o key.txt.age
```

This generates a keypair, prints the public key to stderr (copy it - you need it for step 3), and encrypts the private key with a passphrase you choose. The passphrase-protected `key.txt.age` is safe to commit.

- [ ] **Step 2: Decrypt the key locally for day-to-day use**

```bash
mkdir -p ~/.config/chezmoi
age -d -o ~/.config/chezmoi/key.txt key.txt.age
chmod 600 ~/.config/chezmoi/key.txt
```

Enter the same passphrase. This places the decrypted key where chezmoi expects it.

- [ ] **Step 3: Create `.chezmoi.toml.tmpl`**

Create `~/sysconf/.chezmoi.toml.tmpl` with the public key from step 1 (replace the recipient value):

```toml
mode = "symlink"
encryption = "age"

[age]
  identity = "~/.config/chezmoi/key.txt"
  recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

- [ ] **Step 4: Create the age key decrypt script**

Create `~/sysconf/run_onchange_before_00-decrypt-age-key.sh.tmpl`:

```bash
#!/bin/sh
# key.txt.age hash: {{ include "key.txt.age" | sha256sum }}
if [ ! -f "${HOME}/.config/chezmoi/key.txt" ]; then
    mkdir -p "${HOME}/.config/chezmoi"
    chezmoi age decrypt --passphrase --output "${HOME}/.config/chezmoi/key.txt" \
        "{{ .chezmoi.sourceDir }}/key.txt.age"
    chmod 600 "${HOME}/.config/chezmoi/key.txt"
fi
```

The `sha256sum` comment triggers `run_onchange_` if the key file changes.

- [ ] **Step 5: Commit**

```bash
git add key.txt.age .chezmoi.toml.tmpl run_onchange_before_00-decrypt-age-key.sh.tmpl
git commit -m "chezmoi: set up age encryption"
```

---

### Task 3: Create `.chezmoiignore`

- [ ] **Step 1: Create `.chezmoiignore`**

Create `~/sysconf/.chezmoiignore`:

```
# chezmoi should not deploy these files to the home directory
key.txt.age
fonts
docs
CLAUDE.md
LICENSE
README.md
.gitattributes
.gitignore

# Platform-specific script filtering
{{ if ne .chezmoi.os "darwin" }}
*-darwin.*
*-darwin
dot_config/karabiner
dot_config/linearmouse
dot_config/1password
{{ end }}
{{ if eq .chezmoi.os "darwin" }}
*-fedora.*
*-fedora
*-ubuntu.*
*-ubuntu
{{ end }}
{{ if and (ne .chezmoi.os "darwin") (ne (get .chezmoi.osRelease "id") "fedora") }}
*-fedora.*
*-fedora
{{ end }}
{{ if and (ne .chezmoi.os "darwin") (ne (get .chezmoi.osRelease "id") "ubuntu") }}
*-ubuntu.*
*-ubuntu
{{ end }}
```

- [ ] **Step 2: Commit**

```bash
git add .chezmoiignore
git commit -m "chezmoi: add chezmoiignore with platform filtering"
```

---

### Task 4: Move config files to dot_config

- [ ] **Step 1: Move the config directory**

```bash
cd ~/sysconf
git mv config dot_config
```

- [ ] **Step 2: Verify the move**

```bash
ls dot_config/
```

Expected: `1password direnv fish ghostty git karabiner lazygit linearmouse nvim starship.toml wezterm yt-dlp`

- [ ] **Step 3: Point chezmoi at this repo**

```bash
chezmoi init --source ~/sysconf
```

This tells chezmoi that `~/sysconf` is the source directory.

- [ ] **Step 4: Verify chezmoi sees the files**

```bash
chezmoi managed | head -20
```

Expected: should list paths under `~/.config/` that chezmoi would manage.

- [ ] **Step 5: Dry-run apply to verify symlinks**

```bash
chezmoi apply -n -v 2>&1 | head -40
```

Expected: should show symlink operations from `dot_config/` to `~/.config/`.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chezmoi: move config/ to dot_config/"
```

---

### Task 5: Set up encrypted SSH config

- [ ] **Step 1: Decrypt the current ansible-vault SSH config**

```bash
cd ~/sysconf
ansible-vault view ansible/roles/ssh/files/config.vault > /tmp/ssh_config_plain
```

Enter the vault password when prompted.

- [ ] **Step 2: Create dot_ssh directory and encrypt with age**

```bash
mkdir -p dot_ssh
chezmoi add --encrypt ~/.ssh/config
```

This reads `~/.ssh/config` (which was deployed from the vault file) and creates `dot_ssh/encrypted_private_config.age` (or similar - chezmoi determines the exact name based on encryption + private attributes).

- [ ] **Step 3: Verify the encrypted file was created**

```bash
ls -la dot_ssh/
```

Expected: should show an `encrypted_` prefixed file.

- [ ] **Step 4: Verify round-trip decryption**

```bash
chezmoi cat ~/.ssh/config | head -5
```

Expected: should show the plaintext SSH config contents.

- [ ] **Step 5: Clean up temp file**

```bash
rm /tmp/ssh_config_plain
```

- [ ] **Step 6: Commit**

```bash
git add dot_ssh/
git commit -m "chezmoi: add age-encrypted SSH config"
```

---

### Task 6: Set up encrypted font archive

- [ ] **Step 1: Decrypt the current vault-encrypted font archive**

```bash
cd ~/sysconf
ansible-vault decrypt --output /tmp/fonts.tar.xz ansible/roles/fonts/files/fonts.tar.xz.vault
```

- [ ] **Step 2: Encrypt with age**

```bash
mkdir -p fonts
age -r "$(grep recipient .chezmoi.toml.tmpl | cut -d'"' -f2)" -o fonts/fonts.tar.xz.age /tmp/fonts.tar.xz
```

- [ ] **Step 3: Verify round-trip**

```bash
age -d -i ~/.config/chezmoi/key.txt fonts/fonts.tar.xz.age | file -
```

Expected: should show `XZ compressed data`.

- [ ] **Step 4: Clean up**

```bash
rm /tmp/fonts.tar.xz
```

- [ ] **Step 5: Commit**

```bash
git add fonts/
git commit -m "chezmoi: add age-encrypted font archive"
```

---

### Task 7: Write run_once_before_01-install-homebrew.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_before_01-install-homebrew.sh`:

```bash
#!/bin/bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for subsequent scripts
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_before_01-install-homebrew.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_before_01-install-homebrew.sh
git commit -m "chezmoi: add homebrew install script"
```

---

### Task 8: Write run_onchange_02-install-packages-darwin.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_onchange_02-install-packages-darwin.sh`:

```bash
#!/bin/bash
set -euo pipefail

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- CLI tools ---
brew install \
    1password-cli \
    awscli \
    bat \
    coreutils \
    curl \
    direnv \
    doggo \
    dust \
    eza \
    fd \
    file \
    fzf \
    ghostscript \
    git \
    git-delta \
    git-lfs \
    go \
    httpie \
    imagemagick \
    jq \
    lazydocker \
    lazygit \
    libpq \
    lz4 \
    neovim \
    p7zip \
    parallel \
    podman \
    ripgrep \
    rustup \
    starship \
    tailscale \
    unzip \
    uv \
    wget \
    yt-dlp \
    zoxide

brew link --force libpq

# --- GUI apps ---
brew install --cask \
    1password \
    arc \
    dockutil \
    firefox@developer-edition \
    jetbrains-toolbox \
    karabiner-elements \
    linearmouse \
    monitorcontrol \
    notion-calendar \
    podman-desktop \
    raycast \
    slack \
    the-unarchiver \
    unar \
    utm \
    wezterm

# --- Fish shell (needed by setup-shell script) ---
brew install fish
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_onchange_02-install-packages-darwin.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_onchange_02-install-packages-darwin.sh
git commit -m "chezmoi: add macOS package install script"
```

---

### Task 9: Write run_onchange_02-install-packages-fedora.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_onchange_02-install-packages-fedora.sh`:

```bash
#!/bin/bash
set -euo pipefail

# --- Copr repos ---
sudo dnf copr enable -y \
    atim/bandwhich \
    atim/bottom \
    atim/lazydocker \
    atim/lazygit \
    atim/starship \
    errornointernet/packages \
    wezfurlong/wezterm-nightly

# --- 1Password repo ---
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo tee /etc/yum.repos.d/1password.repo > /dev/null <<'REPO'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
enabled=1
REPO

# --- Packages ---
sudo dnf install -y \
    @development-tools \
    @multimedia \
    1password \
    awscli \
    bat \
    coreutils \
    curl \
    direnv \
    doggo \
    du-dust \
    eza \
    fd-find \
    file \
    firefox \
    fish \
    fzf \
    ghostscript \
    git \
    git-delta \
    git-lfs \
    golang \
    httpie \
    imagemagick \
    jq \
    keychain \
    lazydocker \
    lazygit \
    lz4 \
    neovim \
    p7zip \
    parallel \
    podman \
    postgresql \
    procps-ng \
    ripgrep \
    rustup \
    starship \
    tailscale \
    unzip \
    uv \
    wezterm \
    wget \
    yt-dlp \
    zoxide

# --- Flatpaks (skip on WSL2) ---
if ! uname -r | grep -q WSL2; then
    flatpak install -y flathub io.podman_desktop.PodmanDesktop
fi
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_onchange_02-install-packages-fedora.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_onchange_02-install-packages-fedora.sh
git commit -m "chezmoi: add Fedora package install script"
```

---

### Task 10: Write run_once_before_03-setup-shell.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_before_03-setup-shell.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Find fish binary
if [ -f /opt/homebrew/bin/fish ]; then
    FISH=/opt/homebrew/bin/fish
elif [ -f /home/linuxbrew/.linuxbrew/bin/fish ]; then
    FISH=/home/linuxbrew/.linuxbrew/bin/fish
else
    FISH=$(command -v fish)
fi

# Add fish to allowed shells if not already there
if ! grep -qF "$FISH" /etc/shells; then
    echo "$FISH" | sudo tee -a /etc/shells
fi

# Set fish as default shell
if [ "$SHELL" != "$FISH" ]; then
    sudo chsh -s "$FISH" "$(whoami)"
fi

# Install fisher and update plugins
# NOTE: fisher update must come first so plugins won't be erased from fish_plugins file
$FISH -c '
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
    fisher install jorgebucaran/fisher
'
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_before_03-setup-shell.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_before_03-setup-shell.sh
git commit -m "chezmoi: add shell setup script"
```

---

### Task 11: Write run_once_04-setup-ssh.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_04-setup-ssh.sh`:

```bash
#!/bin/bash
set -euo pipefail

mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Only generate key if it doesn't exist
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "SSH key already exists, skipping generation."
    exit 0
fi

# Prompt for passphrase
echo -n "Enter passphrase for new SSH key: "
read -rs passphrase
echo

# Generate keypair
ssh-keygen -t ed25519 \
    -C "$(whoami)@$(hostname -s)" \
    -f ~/.ssh/id_ed25519 \
    -N "$passphrase"

# Copy public key to clipboard
if [ "$(uname)" = "Darwin" ]; then
    pbcopy < ~/.ssh/id_ed25519.pub
    OPEN=open
else
    xclip -selection clipboard < ~/.ssh/id_ed25519.pub
    OPEN=xdg-open
fi

echo "Public key copied to clipboard."

# Open forge SSH key pages
$OPEN "https://github.com/settings/ssh/new"
$OPEN "https://gitlab.com/-/user_settings/ssh_keys"
$OPEN "https://codeberg.org/user/settings/keys"

echo "Add your SSH key to each forge, then press Enter to continue."
read -r
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_04-setup-ssh.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_04-setup-ssh.sh
git commit -m "chezmoi: add SSH key setup script"
```

---

### Task 12: Write run_once_05-setup-languages.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_05-setup-languages.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Ensure brew is on PATH
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Rust
if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
    rustup-init -y
fi

# Python
uv python install

# pip packages
uv pip install --system pynvim beancount

# Node via fish + nvm.fish
# NOTE: fisher update must come first so plugins won't be erased from fish_plugins file
fish -c '
    fisher update
    fisher install jorgebucaran/nvm.fish
    nvm install lts
'
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_05-setup-languages.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_05-setup-languages.sh
git commit -m "chezmoi: add language setup script"
```

---

### Task 13: Write run_once_06-setup-macos-darwin.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_06-setup-macos-darwin.sh`:

```bash
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
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_06-setup-macos-darwin.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_06-setup-macos-darwin.sh
git commit -m "chezmoi: add macOS system setup script"
```

---

### Task 14: Write run_once_07-install-fonts.sh

- [ ] **Step 1: Create the script**

Create `~/sysconf/run_once_07-install-fonts.sh`:

```bash
#!/bin/bash
set -euo pipefail

if [ "$(uname)" = "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

mkdir -p "$FONT_DIR"

# Decrypt and extract font archive
age -d -i ~/.config/chezmoi/key.txt "$(chezmoi source-path)/fonts/fonts.tar.xz.age" | tar xJ -C "$FONT_DIR"

# Update font cache on Linux
if [ "$(uname)" != "Darwin" ]; then
    fc-cache -vf
fi
```

- [ ] **Step 2: Make executable**

```bash
chmod +x run_once_07-install-fonts.sh
```

- [ ] **Step 3: Commit**

```bash
git add run_once_07-install-fonts.sh
git commit -m "chezmoi: add font install script"
```

---

### Task 15: Remove ansible and old config directory

This is the final cleanup. Only do this after verifying everything works.

- [ ] **Step 1: Dry-run chezmoi apply**

```bash
chezmoi apply -n -v 2>&1 | head -60
```

Verify: should show symlink operations for dot_config files, copy for encrypted SSH config. No errors.

- [ ] **Step 2: Apply chezmoi for real**

```bash
chezmoi apply -v
```

Verify: symlinks created in `~/.config/`, SSH config copied to `~/.ssh/config` with mode 0400.

- [ ] **Step 3: Spot-check symlinks**

```bash
ls -la ~/.config/nvim/init.lua
ls -la ~/.config/fish/config.fish
ls -la ~/.config/git/config
ls -la ~/.ssh/config
```

Expected: first three should be symlinks to `~/sysconf/dot_config/...`, SSH config should be a regular file with mode 0400.

- [ ] **Step 4: Remove ansible directory and config**

```bash
git rm -r ansible/
git rm ansible.cfg
```

- [ ] **Step 5: Remove old config directory**

The `config/` directory was already moved to `dot_config/` in Task 4. If any remnants exist:

```bash
git rm -r config/ 2>/dev/null || true
```

- [ ] **Step 6: Remove git-lfs tracking for fonts**

The fonts are now age-encrypted directly in the repo, no longer LFS-tracked:

```bash
git rm ansible/roles/fonts/.gitattributes 2>/dev/null || true
```

If there's a root `.gitattributes` with LFS rules for fonts, remove those lines too.

- [ ] **Step 7: Update .gitignore if needed**

Ensure `.gitignore` doesn't reference ansible-specific paths. Add if not present:

```
# chezmoi decrypted key (never commit)
key.txt
```

- [ ] **Step 8: Commit**

```bash
git add -A
git commit -m "chezmoi: remove ansible and complete migration"
```

---

### Task 16: Final verification

- [ ] **Step 1: Run chezmoi doctor**

```bash
chezmoi doctor
```

Verify: all checks pass (or only expected warnings).

- [ ] **Step 2: Run chezmoi diff**

```bash
chezmoi diff
```

Expected: empty output (no drift between source and target).

- [ ] **Step 3: Verify editing workflow**

```bash
# Edit a config file in place
echo "# test" >> ~/.config/nvim/init.lua
# Verify the change is in the source dir (symlink)
tail -1 ~/sysconf/dot_config/nvim/init.lua
# Revert
git -C ~/sysconf checkout dot_config/nvim/init.lua
```

- [ ] **Step 4: Verify encrypted file editing**

```bash
chezmoi edit ~/.ssh/config
```

Expected: opens the decrypted SSH config in your editor. After saving and closing, the file is re-encrypted in the source dir.

- [ ] **Step 5: Clean up docs**

Remove the spec and plan files (they're in git history):

```bash
rm -rf ~/sysconf/docs/
git add -A
git commit -m "chore: remove design docs (preserved in git history)"
```

---

## Self-review

**Spec coverage check:**
- Source directory as repo root: Task 4 (init --source)
- Symlink mode: Task 2 (.chezmoi.toml.tmpl), Task 15 (verification)
- age encryption: Tasks 2, 5, 6
- Platform filtering: Task 3
- Bootstrap one-liner: covered in spec, not a task (it's how you'd use this on a new machine)
- All 8 scripts (00-07): Tasks 2, 7-14
- File moves: Tasks 4 (dot_config), 5 (SSH), 6 (fonts)
- Ansible removal: Task 15
- Legacy cleanup (per-identity SSH keys): intentionally dropped per spec
- Testing: Task 16

**Placeholder scan:** No TBDs, TODOs, or "fill in later" found.

**Consistency check:** age recipient key referenced consistently in .chezmoi.toml.tmpl and font encryption command. Script numbering is consistent across filenames and task descriptions.
