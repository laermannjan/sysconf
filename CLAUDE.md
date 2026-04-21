# CLAUDE.md

Guidance for contributing to this repository.

## Purpose

Personal system configuration repository. Bootstraps macOS/Linux dev machines: packages, shell, dotfiles, system preferences. Goal is "just works" - zero friction on the live system, automated bidirectional sync between repo and system. Setup must justify itself. Simplicity wins over cleverness.

## Principles

1. **Optimize for the live system** - System usability beats setup code quality. When automation becomes brittle, manual is acceptable.
2. **Simplicity and clarity** - Code must be understandable months or years later. Zero unnecessary dependencies.
3. **Completeness over shortcuts** - Edge cases and platform differences must be handled. Setup debt isn't worth live system complexity.
4. **Defensive defaults** - Error handling is mandatory. Fail early with clear messages. Never leave system in broken state.
5. **Plain bash** - Tools like Ansible/Nix/Chezmoi all add dependency chains that break after inactivity. Bash won't.

## Bidirectional Flow

Configs live in `config/` and are symlinked to `~/.config/`. This enables true bidirectional sync: edit files live on the system, changes are tracked in git automatically. Bootstrap restores state to any machine. No templates, no transformation - just symlinks.

## When Making Changes

- Keep scripts focused - one responsibility per file
- Explicit over implicit - avoid magic, assume nothing
- Test on a clean system when possible
- All scripts must pass `shellcheck`
- Error handling is mandatory - fail early with clear messages

## Security

- NEVER commit SSH keys, API tokens, passwords
- Check for unencrypted secrets before any commit
- Config files must contain only settings/aliases, no credentials

## Platform Notes

macOS is primary, Linux (Fedora/Debian) is secondary. Platform-specific logic is acceptable when necessary. Prefer Homebrew for CLI tools across all platforms.
