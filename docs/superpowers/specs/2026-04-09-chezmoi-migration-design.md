# Chezmoi Migration Design Spec

## Goal

Replace ansible with chezmoi for managing personal system configuration across
macOS and Fedora machines. Preserve the edit-in-place workflow via symlink mode.

## Context

The current ansible-based setup works but fights the tool's assumptions - ansible
is designed for managing fleets of remote servers, not a single laptop. Inventory
warnings, privilege escalation quirks, vars_prompt always firing, vault passwords
prompted upfront regardless of tags - these are all symptoms of a mismatch between
the tool and the use case.

chezmoi is purpose-built for managing dotfiles and personal machine configuration
across multiple machines. It supports encryption (age), templating (Go templates),
platform conditionals, and a bootstrap-from-URL workflow.

## Architecture

### Source directory

The git repo (`~/sysconf`) is the chezmoi source directory. chezmoi manages files
under `dot_config/`, `dot_ssh/`, and the repo root for scripts and data files.

### Symlink mode

chezmoi is configured with `mode = "symlink"`. This makes `chezmoi apply` create
symlinks instead of copies for regular, non-encrypted, non-private, non-templated
files. This preserves the current edit-in-place workflow for ~95% of config files
(nvim, fish, wezterm, git, starship, lazygit, etc.).

Files that cannot be symlinked (encrypted SSH config, private files with
restrictive permissions) are copied. This is fine - they're rarely edited.

### Encryption

Switch from ansible-vault to age. chezmoi has native age support. Encrypted files
use the `encrypted_` prefix in the source directory and are transparently
decrypted on `chezmoi apply`.

Currently encrypted files:
- SSH config (`~/.ssh/config`) - encrypted + private (0400), always copied
- Font archive - encrypted, extracted by script

Editing encrypted files: `chezmoi edit <target>` decrypts to a temp file, opens
the editor, re-encrypts on save.

### Platform filtering

`.chezmoiignore` uses glob patterns to skip platform-specific files:

```
{{ if ne .chezmoi.os "darwin" }}
*-darwin.*
*-darwin
{{ end }}
{{ if ne .chezmoi.osRelease.id "fedora" }}
*-fedora.*
*-fedora
{{ end }}
{{ if ne .chezmoi.osRelease.id "ubuntu" }}
*-ubuntu.*
*-ubuntu
{{ end }}
```

Files with no platform suffix run everywhere. Files with `-darwin`, `-fedora`,
or `-ubuntu` suffix are ignored on other platforms.

For directories that only exist on one platform (e.g. `karabiner/`,
`linearmouse/`), add explicit entries to `.chezmoiignore`:

```
{{ if ne .chezmoi.os "darwin" }}
dot_config/karabiner
dot_config/linearmouse
dot_config/1password
{{ end }}
```

### Bootstrap

One-liner for a fresh machine:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply laermannjan/sysconf
```

This installs the chezmoi binary and runs `init --apply` which clones the repo
and applies everything. `run_once_before_` scripts run first (Homebrew, packages,
shell setup), then chezmoi applies file state (symlinks, copies, encrypted files),
then `run_once_` scripts run for remaining setup. No separate install script
needed.

## Repository structure

```
~/sysconf/
  .chezmoi.toml.tmpl          # chezmoi config (symlink mode, age encryption, editor)
  .chezmoiignore              # platform glob filters
  dot_config/                 # -> ~/.config/
    nvim/
      init.lua
      lsp/
    fish/
      config.fish
      conf.d/
      functions/
      completions/
      fish_plugins
    git/
      config
      config.alcemy
      config.personal
      ignore
    wezterm/
      wezterm.lua
    starship.toml
    lazygit/
      config.yml
    karabiner/
    linearmouse/
    ghostty/
    direnv/
    1password/
    yt-dlp/

  dot_ssh/
    encrypted_private_config.age  # SSH config, age-encrypted + private (0400)

  key.txt.age                 # passphrase-protected age private key

  run_onchange_before_00-decrypt-age-key.sh.tmpl
  run_once_before_01-install-homebrew.sh
  run_onchange_02-install-packages-darwin.sh
  run_onchange_02-install-packages-fedora.sh
  run_once_before_03-setup-shell.sh
  run_once_04-setup-ssh.sh
  run_once_05-setup-languages.sh
  run_once_06-setup-macos-darwin.sh
  run_once_07-install-fonts.sh

  fonts/                      # age-encrypted font archive (not in dot_ path)
    fonts.tar.xz.age
```

## Scripts

### 00 - Decrypt age key (`run_onchange_before_00-decrypt-age-key.sh.tmpl`)

Decrypts `key.txt.age` to `~/.config/chezmoi/key.txt` if it doesn't already
exist. Prompts for the passphrase. Runs before any other script so encrypted
files can be decrypted during apply.

Platform: both.

### 01 - Install Homebrew (`run_once_before_01-install-homebrew.sh`)

Installs Homebrew on macOS or Linuxbrew on Linux. Uses the official Homebrew
install script. Runs before apply so that subsequent scripts can use `brew`.

Platform: both (Homebrew install script detects OS).

### 02 - Install packages (`run_onchange_02-install-packages-{darwin,fedora}.sh`)

**macOS (`-darwin`):**
- `brew install <cli packages>`
- `brew install --cask <gui apps>`
- `brew link --force libpq`

**Fedora (`-fedora`):**
- Enable copr repos (lazygit, starship, lazydocker, wezterm, etc.)
- Add 1Password RPM repo
- `sudo dnf install -y <packages>`
- Install flatpaks (podman-desktop) when not on WSL2

Uses `run_onchange_` so editing the package list triggers reinstall.

### 03 - Setup shell (`run_once_before_03-setup-shell.sh`)

Fish is already installed by script 02 (in the package list). This script:
- Add fish to `/etc/shells`
- Set fish as default shell via `chsh`
- Install fisher and run `fisher update`

Platform: both.

### 04 - Setup SSH (`run_once_04-setup-ssh.sh`)

- Ensure `~/.ssh` exists with mode 0700
- Check if `~/.ssh/id_ed25519` exists
- If not: prompt for passphrase, generate ed25519 keypair
- Copy public key to clipboard (`pbcopy` / `xclip`)
- Open forge SSH key pages (GitHub, GitLab, Codeberg) in browser
- Pause for user to add keys

Platform: both, with `uname` check for clipboard/browser commands.

### 05 - Setup languages (`run_once_05-setup-languages.sh`)

- `rustup-init -y` (if cargo not found)
- `uv python install`
- Install Node via fish + nvm.fish (`fisher install jorgebucaran/nvm.fish && nvm install lts`)
- `pip install pynvim beancount` (or via uv)

Platform: both.

### 06 - Setup macOS (`run_once_06-setup-macos-darwin.sh`)

- All `defaults write` commands (NSGlobalDomain, Dock, Finder, etc.)
- Enable TouchID for sudo (`pam_tid.so`)
- Show ~/Library, /Volumes
- PlistBuddy snap-to-grid for Finder
- Dock configuration via `dockutil`:
  - Remove: Launchpad, Safari, Messages, Maps, Photos, FaceTime, Contacts,
    Reminders, Notes, Calendar, TV, Podcasts, App Store
  - Add: Finder, Arc, Firefox Developer Edition, WezTerm, Slack, Notion Calendar,
    Mail, 1Password, System Settings (with positions)
- `killall Dock` at end

Platform: macOS only (filtered by `-darwin` suffix).

### 07 - Install fonts (`run_once_07-install-fonts.sh`)

- Determine font directory (`~/Library/Fonts` on macOS, `~/.local/share/fonts`
  on Linux)
- Decrypt and extract `fonts.tar.xz.age` to font directory
- Run `fc-cache -vf` on Linux

Platform: both, with `uname` check for font dir and cache.

## chezmoi configuration

`.chezmoi.toml.tmpl`:

```toml
mode = "symlink"
encryption = "age"

[age]
  identity = "~/.config/chezmoi/key.txt"
  recipient = "age1..."  # public key from keygen
```

### Age key management

age uses an asymmetric keypair. The private key is encrypted with a passphrase
and committed to the repo as `key.txt.age`. A `run_onchange_before_` script
decrypts it on first run.

**Committed files for encryption:**
- `key.txt.age` - passphrase-protected age private key (safe to commit)
- `run_onchange_before_00-decrypt-age-key.sh.tmpl` - decrypts key on first run
- `.chezmoi.toml.tmpl` - contains the age public key (recipient)
- `.chezmoiignore` includes `key.txt.age` so chezmoi doesn't deploy it

**One-time setup (during migration):**
1. Generate age keypair: `chezmoi age-keygen | chezmoi age encrypt --passphrase --output key.txt.age`
2. Note the public key from the keygen output
3. Hardcode the public key in `.chezmoi.toml.tmpl`
4. Decrypt locally: `chezmoi age decrypt --passphrase --output ~/.config/chezmoi/key.txt key.txt.age`
5. Encrypt files with `chezmoi add --encrypt <file>`

**Fresh machine bootstrap:**
1. Run the bootstrap one-liner (installs chezmoi, clones repo)
2. `run_onchange_before_00-decrypt-age-key.sh.tmpl` runs automatically
3. User is prompted for the passphrase (once)
4. Private key is decrypted to `~/.config/chezmoi/key.txt`
5. All subsequent decryption works automatically, no more prompts

This is comparable to the current ansible-vault workflow (passphrase on first
run), but the key is then cached locally so day-to-day operations never prompt.

## Migration from ansible

### What gets deleted
- `ansible/` directory (all roles, playbook, requirements, install script)
- `ansible.cfg`
- `config/` directory (contents move to `dot_config/`)

### What moves
- `config/*` -> `dot_config/*` (rename only, same files)
- `ansible/roles/ssh/files/config.vault` -> `dot_ssh/encrypted_config.age`
  (re-encrypt with age)
- `ansible/roles/fonts/files/fonts.tar.xz.vault` -> `fonts/fonts.tar.xz.age`
  (re-encrypt with age)

### What's rewritten
- All ansible role logic -> shell scripts with `run_once_`/`run_onchange_` prefixes
- Bootstrap becomes a one-liner (no install script in repo)

### Legacy cleanup
- Per-identity SSH key removal (already handled in current ansible, can be
  dropped since it's a one-time migration)
- git-lfs dependency for fonts goes away (age-encrypted in repo directly)

## Testing

After migration:
1. `chezmoi diff` - verify what would change before applying
2. `chezmoi apply -n` (dry run) - verify no errors
3. `chezmoi apply` on current machine - verify symlinks created, scripts run
4. Test bootstrap on a fresh VM or container
