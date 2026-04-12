# sysconf

Personal system configuration managed with [chezmoi](https://www.chezmoi.io) in symlink mode.

## Fresh install

### macOS

```bash
xcode-select --install  # opens a dialog - wait for it to complete
curl -fsLS https://raw.githubusercontent.com/laermannjan/sysconf/main/bootstrap.sh | bash
```

### Fedora

```bash
sudo dnf install -y curl
curl -fsLS https://raw.githubusercontent.com/laermannjan/sysconf/main/bootstrap.sh | bash
```

The bootstrap script installs chezmoi, clones this repo to `~/sysconf`, and runs `chezmoi apply`.

You will be prompted for:
- **Age passphrase** - to decrypt the private key on first run
- **sudo** - for package installation and shell setup
- **SSH key passphrase** - when generating a new SSH key

## Day-to-day

```bash
# Apply changes after editing config files
chezmoi apply

# Pull latest and apply
chezmoi update

# Add a new font (re-packs archive automatically on next apply)
cp MyFont.ttf ~/Library/Fonts/
chezmoi apply
```

## Post-install

- **macOS**: disable the window switcher in `Settings > Keyboard > Keyboard Shortcuts > Keyboard > Move focus to next window` so WezTerm's **CMD+`** workspace shortcut works

## Secrets

SSH config and fonts are encrypted with [age](https://age-encryption.org). The passphrase-protected private key (`key.txt.age`) is committed to this repo and decrypted on first run.

To edit encrypted files:
```bash
chezmoi edit ~/.ssh/config
```
