# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal system configuration repository for bootstrapping and syncing development environments across machines (primarily macOS and Fedora/WSL2). Designed with a "just works" philosophy - should remain functional after weeks or months of inactivity.

## Core Principles

1. **Privacy and Security First** - Secrets MUST be encrypted at all times, no exceptions
2. **Simplicity over cleverness** - Code should be understandable months/years later
3. **Defensive programming** - Explicit error handling, fail early with clear messages
4. **Resiliency** - Bootstrap process must never leave system in broken state
5. **Maintainability** - Clear structure, minimal dependencies, obvious intent

## Critical Commands

```bash
# Bootstrap a new machine (the ONE command that must always work)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/ansible/install.sh)"

# Update existing configuration
cd ~/sysconf/ansible && ansible-playbook playbook.yml

# Update encrypted secrets
VAULT_PASSWORD_FILE=/tmp/vaultpw ~/sysconf/ansible/update-secrets.sh
```

## Architecture for Resiliency

### Bootstrap Safety
- `ansible/install.sh` is the critical entry point - must handle all edge cases
- Uses standard tools available on fresh systems (curl, git, bash)
- Checks prerequisites before making any changes
- Creates backups of existing configurations before symlinking

### Configuration Structure
- **Ansible roles** provide modular, testable units of configuration
- **Idempotent operations** - safe to run multiple times
- **Platform detection** - separate logic for macOS vs Linux/WSL2
- **Encrypted vault** for sensitive data - fails safely if password incorrect

### Key Design Decisions

1. **Why Ansible?** 
   - Declarative configuration reduces complexity
   - Built-in error handling and reporting
   - Idempotent by design
   - Clear YAML syntax readable years later

2. **Configuration Symlinks**
   - All configs live in `~/sysconf/config/`
   - Ansible creates symlinks to expected locations
   - Easy to track changes in git
   - Original configs backed up before linking

3. **Package Management**
   - Homebrew on macOS (widely supported, stable)
   - Native package managers on Linux (dnf for Fedora)
   - Packages defined in simple lists in ansible roles

4. **Error Handling Strategy**
   - Install script validates environment before proceeding
   - Ansible stops on first error (fail-fast)
   - Clear error messages indicate what went wrong
   - No silent failures or ambiguous states

### Common Failure Points to Guard Against

1. **Missing prerequisites** - Check for git, ansible, package managers
2. **Network issues** - Retry logic for package downloads
3. **Permission errors** - Clear messages about sudo requirements
4. **Existing configurations** - Always backup before overwriting
5. **Platform differences** - Explicit conditionals for macOS/Linux
6. **Vault password** - Graceful handling of authentication failures

## Security and Secrets Management

### CRITICAL SECURITY RULES

1. **ALL secrets MUST be encrypted using ansible-vault**
2. **Files with `.vault` extension contain encrypted data**
3. **NEVER commit unencrypted sensitive files**
4. **ALWAYS check for unencrypted secrets before committing**

### What Constitutes a Secret?
- SSH private keys
- API tokens and keys
- Passwords and passphrases
- AWS credentials
- Database connection strings
- Any personal or identifying information

### Before ANY Git Operations
```bash
# Check for potential unencrypted secrets
find . -type f -name "*.key" -o -name "*.pem" -o -name "*_rsa" -o -name "*_dsa" -o -name "*_ecdsa" -o -name "*_ed25519" | grep -v ".vault"
grep -r "PRIVATE KEY" --exclude="*.vault" .
grep -r "password\|token\|secret\|key" --exclude="*.vault" config/
```

### Working with Vault Files
```bash
# View encrypted file
ansible-vault view ansible/vault/file.vault

# Edit encrypted file
ansible-vault edit ansible/vault/file.vault

# Encrypt a new file
ansible-vault encrypt newfile --output ansible/vault/newfile.vault
```

**WARNING**: If you find ANY unencrypted sensitive file, STOP immediately and:
1. DO NOT commit
2. Remove from git history if already staged
3. Encrypt using ansible-vault
4. Alert the user about the security risk

## When Making Changes

- **SECURITY FIRST** - Always verify no secrets are exposed
- Test changes on a clean system when possible
- Keep ansible roles focused and single-purpose
- Document non-obvious decisions in comments
- Prefer explicit over implicit behavior
- If something could fail, add error handling
- Maintain backwards compatibility with existing setups