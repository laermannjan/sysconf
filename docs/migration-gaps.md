# Chezmoi Migration - Gaps and Open Questions

## Gaps

### 1. No Debian/Ubuntu package script
Ansible had `debian.yml` with 1Password + WezTerm apt repos, GPG keys,
`apt update_cache`, and Debian-specific packages (`build-essential`, `man-db`,
`procps`, `postgres-client`). The chezmoi migration only has `-darwin` and
`-fedora` scripts. `.chezmoiignore` has ubuntu patterns but no matching script.

### 2. `run_once_` scripts won't re-run
Ansible was idempotent - re-run the playbook anytime to converge state. chezmoi
`run_once_` scripts only run once, ever. Affected scripts:
- `run_once_06-setup-macos-darwin.sh` - macOS defaults won't reapply after OS update
- `run_once_before_03-setup-shell.sh` - shell setup
- `run_once_04-setup-ssh.sh` - SSH key gen (fine as run_once)
- `run_once_05-setup-languages.sh` - language toolchains

Options: change to `run_onchange_` (re-runs when content changes), run manually,
or clear chezmoi script state.

### 3. Fish listed redundantly in darwin packages
`brew install fish` is tacked on at the end of the darwin script but not in the
main `brew install` block. Should be consolidated.

### 4. pip install approach changed
Ansible used `pip3 install pynvim beancount` (system pip). chezmoi script uses
`uv pip install --system pynvim beancount`. Behavior may differ.

### 5. Missing `creates` guards in languages script
Ansible had guards to skip already-installed tools:
- `creates: ~/.cargo/bin/cargo` for rustup (preserved in chezmoi)
- `creates: ~/.local/share/nvm/*/bin/node` for node (missing)
- `creates: ~/.local/share/uv/python/*/` for python (missing)

Since these are `run_once_` scripts it only matters on first run, but
`uv python install` and `nvm install lts` would re-download if partially set up.

### 6. No `fc-cache -vf` on Linux after font extraction
The `.chezmoiexternal` approach extracts fonts but doesn't update the font cache.
Most modern Linux desktops auto-detect, but some apps need `fc-cache`. Could add
a small `run_after_` script for Linux.

## Open Questions

1. **Debian/Ubuntu support needed?** Or only macOS + Fedora going forward?
2. **Should macOS defaults be `run_onchange_`?** Allows re-trigger by editing
   the script, at the cost of re-running all defaults on any change.
3. **`uv pip install --system` vs `pip3`?** Has this been tested?
