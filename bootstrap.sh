#!/bin/bash
set -euo pipefail

CHEZMOI_REPO="laermannjan/sysconf"
CHEZMOI_BIN="$HOME/.local/bin"

# Colors (duplicated from lib.sh - bootstrap runs before chezmoi)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_section() { printf "\n${BOLD}${BLUE}==> %s${NC}\n" "$1"; }
log_ok()      { printf "  ${GREEN}ok${NC}       %s\n" "$1"; }
log_changed() { printf "  ${YELLOW}changed${NC}  %s\n" "$1"; }
log_error()   { printf "  ${RED}error${NC}    %s\n" "$1" >&2; }

OS=$(uname -s)

# ============================================================================
# macOS: Xcode CLI tools
# ============================================================================

if [ "$OS" = "Darwin" ]; then
    log_section "Xcode CLI tools"
    if xcode-select -p &>/dev/null; then
        log_ok "Already installed"
    else
        log_changed "Starting installation - follow the dialog to complete"
        xcode-select --install
        echo
        echo "Re-run this script after Xcode CLI tools finish installing."
        exit 0
    fi
fi

# ============================================================================
# chezmoi
# ============================================================================

log_section "chezmoi"
if command -v chezmoi &>/dev/null; then
    log_ok "Already installed at $(command -v chezmoi)"
else
    log_changed "Installing to $CHEZMOI_BIN"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$CHEZMOI_BIN"
    log_ok "Installed"
fi

export PATH="$CHEZMOI_BIN:$PATH"

# ============================================================================
# Apply dotfiles
# ============================================================================

log_section "Applying dotfiles"
chezmoi init --apply "$CHEZMOI_REPO"
