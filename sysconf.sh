#!/usr/bin/env bash

set -euo pipefail

PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"

SYSCONF_DIR="${SYSCONF_DIR:-${HOME}/sysconf}"
export SYSCONF_DIR

# --- Helpers (used by all setup scripts via source) ---

has()      { command -v "$1" &>/dev/null; }
is_mac()   { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
is_debian(){ [[ -f /etc/debian_version ]]; }
is_redhat(){ [[ -f /etc/redhat-release ]]; }
is_wsl2()  { [[ -f /proc/version ]] && grep -qi microsoft /proc/version; }

_color() { printf '\033[%sm' "$1"; }
_reset() { printf '\033[0m'; }
log()      { printf '%s==>%s %s\n' "$(_color '1;34')" "$(_reset)" "$1"; }
log_ok()   { printf '  %s✓%s %s\n' "$(_color '32')" "$(_reset)" "$1"; }
log_skip() { printf '  %s- %s%s\n' "$(_color '2')" "$1" "$(_reset)"; }
log_warn() { printf '  %s! %s%s\n' "$(_color '33')" "$1" "$(_reset)"; }

# --- Skip configuration ---
# Via CLI: --skip ssh --skip system
# Via env: SYSCONF_SKIP="ssh,system" (comma-separated, for fish aliases etc.)

SKIP=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip) SKIP+=("$2"); shift 2 ;;
        *) shift ;;
    esac
done

if [[ -n "${SYSCONF_SKIP:-}" ]]; then
    IFS=',' read -ra _env_skip <<< "$SYSCONF_SKIP"
    SKIP+=("${_env_skip[@]}")
fi

if [[ -n "${NONINTERACTIVE:-}" ]]; then
    SKIP+=(ssh)
fi

should_skip() { printf '%s\n' "${SKIP[@]}" | grep -qx "$1" 2>/dev/null; }

# --- Bootstrap prerequisites ---

log "Bootstrapping prerequisites"

if is_linux && ! has git; then
    log "Installing build tools and git"
    if has apt-get; then
        sudo apt-get update -y || true
        sudo apt-get install -y build-essential curl file git
    elif has dnf; then
        sudo dnf check-update || true
        sudo dnf install -y curl file git gcc-c++ make procps-ng
    fi
    log_ok "Build tools"
fi

if has brew; then
    log_skip "Homebrew (already installed)"
else
    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_ok "Homebrew"
fi
eval "$(brew shellenv)"

if [[ -d "${SYSCONF_DIR}/.git" ]]; then
    log_skip "Repository (already cloned)"
else
    log "Cloning sysconf repository"
    git clone https://github.com/laermannjan/sysconf.git "${SYSCONF_DIR}"
    # make ssh the primary, keep https so we can fetch updates before ssh keys are installed
    git -C "${SYSCONF_DIR}" remote set-url --push origin git@github.com:laermannjan/sysconf.git
    log_ok "Repository"
fi

pushd "${SYSCONF_DIR}" >/dev/null
# Pull latest changes if on a branch (skip on detached HEAD, e.g. CI checkout)
if git symbolic-ref -q HEAD &>/dev/null; then
    git pull --ff-only || log_warn "Could not fast-forward, continuing with local state"
fi

# --- Run setup ---

# Single sudo prompt, then keep credentials alive for the duration.
# Skip if already root (e.g. container).
if [[ "$(id -u)" -ne 0 ]]; then
    sudo -v
    while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!
    trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT
fi

should_skip dotfiles || source setup/dotfiles.sh  # first: brew bundle needs ~/.config/homebrew/Brewfile
should_skip packages || source setup/packages.sh  # second: installs fish, flatpak, etc.
should_skip shell    || source setup/shell.sh
should_skip system   || source setup/system.sh
should_skip ssh      || source setup/ssh.sh       # last: only interactive step

popd >/dev/null

log "Done"
echo "Run 'exec fish' to pick up changes (including docker group)."
