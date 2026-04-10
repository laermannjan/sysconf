# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal system configuration repository for bootstrapping and syncing development environments across machines (primarily macOS and Fedora/WSL2). Managed with chezmoi in symlink mode. Designed with a "just works" philosophy - should remain functional after weeks or months of inactivity.

## Core Principles

1. **Privacy and Security First** - Secrets MUST be encrypted at all times, no exceptions
2. **Simplicity over cleverness** - Code should be understandable months/years later
3. **Defensive programming** - Explicit error handling, fail early with clear messages
4. **Resiliency** - Bootstrap process must never leave system in broken state
5. **Maintainability** - Clear structure, minimal dependencies, obvious intent

## Critical Commands

```bash
# Bootstrap a new machine (the ONE command that must always work)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply laermannjan/sysconf

# Apply changes after editing config files
chezmoi apply

# Edit encrypted SSH config
chezmoi edit ~/.ssh/config

# Update font archive after adding new fonts
./update-fonts.sh ~/Library/Fonts  # macOS
./update-fonts.sh ~/.local/share/fonts  # Linux

# Check what chezmoi would change
chezmoi diff
```

## Architecture

### How chezmoi works here
- This repo IS the chezmoi source directory (`~/sysconf/`)
- **Symlink mode**: most config files in `dot_config/` are symlinked to `~/.config/`, so editing in place works
- **Encrypted files** (SSH config) are copied, not symlinked - edit via `chezmoi edit`
- **Platform-specific scripts** use name suffixes (`-darwin`, `-fedora`) filtered by `.chezmoiignore`
- **Encryption** uses age with a passphrase-protected key (`key.txt.age` in repo)

### Key directories
- `dot_config/` - config files, symlinked to `~/.config/`
- `private_dot_ssh/` - SSH config (encrypted with age)
- `fonts/` - age-encrypted font archive, deployed via `.chezmoiexternal.toml.tmpl`
- `run_once_*` / `run_onchange_*` - setup scripts that run during `chezmoi apply`

### Platform filtering
- Files ending in `-darwin` are ignored on Linux
- Files ending in `-fedora` are ignored on macOS and non-Fedora Linux
- Files ending in `-ubuntu` are ignored on macOS and non-Ubuntu Linux
- macOS-only directories (karabiner, linearmouse, 1password) are explicitly ignored on Linux

## Security and Secrets Management

### CRITICAL SECURITY RULES

1. **ALL secrets MUST be encrypted using age**
2. **Files with `.age` extension contain encrypted data**
3. **NEVER commit unencrypted sensitive files**
4. **The decrypted age key (`~/.config/chezmoi/key.txt`) must NEVER be committed**

### What Constitutes a Secret?
- SSH private keys and config
- API tokens and keys
- Passwords and passphrases
- Any personal or identifying information

### Working with Encrypted Files
```bash
# Edit encrypted SSH config (decrypts, opens editor, re-encrypts)
chezmoi edit ~/.ssh/config

# Add a new encrypted file
chezmoi add --encrypt <file>

# Encrypt the font archive
./update-fonts.sh <font-directory>
```

**WARNING**: If you find ANY unencrypted sensitive file, STOP immediately and:
1. DO NOT commit
2. Remove from git history if already staged
3. Encrypt using `chezmoi add --encrypt`
4. Alert the user about the security risk

## When Making Changes

- **SECURITY FIRST** - Always verify no secrets are exposed
- Edit config files in place (they're symlinks to the source dir)
- Use `chezmoi diff` to verify before applying
- Platform-specific scripts use name suffixes, not template conditionals
- Prefer explicit over implicit behavior
- If something could fail, add error handling
