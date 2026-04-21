# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal system configuration repository for bootstrapping and syncing development environments across machines (primarily macOS and Fedora/WSL2). Designed with a "just works" philosophy - should remain functional after weeks or months of inactivity.

## Core Principles

1. **Simplicity over cleverness** - Code should be understandable months/years later
2. **Defensive programming** - Explicit error handling, fail early with clear messages
3. **Resiliency** - Bootstrap process must never leave system in broken state
4. **Maintainability** - Clear structure, minimal dependencies, obvious intent
5. **Zero unnecessary dependencies** - Only bash, curl, and git on a fresh system

## Critical Commands

```bash
# Bootstrap a new machine (the ONE command that must always work)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/sysconf.sh)"

# Update existing configuration
cd ~/sysconf && bash sysconf.sh

# Skip specific steps
bash sysconf.sh --skip ssh --skip system
```

## Architecture

### Structure
```
sysconf.sh          # bootstrap + helpers + orchestration (sources setup scripts)
setup/
  packages.sh       # brew bundle + platform dispatch
  packages-debian.sh
  packages-redhat.sh
  dotfiles.sh       # symlink config/ -> ~/.config/
  shell.sh          # install fish, set as default
  ssh.sh            # keypair generation, config deployment
  system.sh         # macOS defaults, TouchID, Finder
config/             # all dotfiles, symlinked into ~/.config/
```

### Bootstrap Safety
- `sysconf.sh` is the critical entry point - must handle all edge cases
- Only requires curl and bash on a fresh system (git is installed via brew if missing)
- All operations are naturally idempotent - safe to run repeatedly
- Platform detection via `lib/platform.sh` drives all conditionals

### Key Design Decisions

1. **Plain bash over configuration management tools** - Ansible/chezmoi/pyinfra all add a dependency chain that can break after months of inactivity. Bash won't.

2. **Configuration symlinks** - All configs live in `~/sysconf/config/`, symlinked to `~/.config/`. Edit in place, changes tracked in git.

3. **One file per concern** - Each setup script handles one domain (packages, shell, ssh, etc.). Easy to skip, debug, or extend independently.

4. **Package management** - Homebrew on all platforms for CLI tools. Native package managers (apt/dnf) for system packages and repo setup on Linux.

### Common Failure Points to Guard Against

1. **Missing prerequisites** - sysconf.sh installs brew, git before anything else
2. **Network issues** - Package install failures shouldn't halt the entire run
3. **Permission errors** - `sudo -v` upfront, scripts use `sudo` directly where needed
4. **Existing configurations** - Symlinks overwrite via `ln -sf`, real directories removed before linking
5. **Platform differences** - Explicit conditionals via `lib/platform.sh`

## Security

- NEVER commit SSH private keys, API tokens, passwords, or credentials
- Check for unencrypted secrets before committing
- SSH config in `config/ssh/config` must not contain secrets (host aliases and options only)

## When Making Changes

- Test changes on a clean system when possible
- Keep setup scripts focused and single-purpose
- Prefer explicit over implicit behavior
- If something could fail, add error handling
- Run `shellcheck` on all scripts before committing
