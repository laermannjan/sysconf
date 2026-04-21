#!/usr/bin/env bash

set -euo pipefail

PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"

SYSCONF_DIR="${SYSCONF_DIR:-${HOME}/sysconf}"
export SYSCONF_DIR

USER="${USER:-$(whoami)}"
export USER

# --- Helpers (used by all setup scripts via source) ---

has()      { command -v "$1" &>/dev/null; }
is_mac()   { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
is_debian(){ [[ -f /etc/debian_version ]]; }
is_redhat(){ [[ -f /etc/redhat-release ]]; }
is_wsl2()  { [[ -f /proc/version ]] && grep -qi microsoft /proc/version; }

log()      { printf '\033[1;34m[sysconf] %s\033[0m\n' "$1"; }
log_ok()   { printf '\033[32m[sysconf]   ✓ %s\033[0m\n' "$1"; }
log_skip() { printf '\033[2m[sysconf]   - %s\033[0m\n' "$1"; }
log_warn() { printf '\033[33m[sysconf]   ! %s\033[0m\n' "$1"; }

# Run command silently, show output only on failure
quiet() {
    local out
    if out=$("$@" 2>&1); then
        return 0
    else
        local rc=$?
        printf '%s\n' "$out"
        return "$rc"
    fi
}

# --- Skip configuration ---
# Via CLI: --skip ssh --skip system
# Via env: SYSCONF_SKIP="ssh,system" (comma-separated, for fish aliases etc.)

SKIP=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip) SKIP+=("$2"); shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
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

log "Prerequisites"

if is_linux; then
    log "Build tools"
    if has apt-get; then
        quiet sudo apt-get update -y
        sudo apt-get install -y build-essential curl file git
    elif has dnf; then
        sudo dnf group install -y c-development development-libs development-tools
        sudo dnf install -y curl file git
    fi
    log_ok "build tools"
fi

if has brew; then
    log_skip "homebrew"
else
    log "Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_ok "homebrew"
fi
eval "$(brew shellenv bash)"

if [[ -f "${SYSCONF_DIR}/sysconf.sh" ]]; then
    log_skip "repo"
else
    log "Cloning repo"
    git clone https://github.com/laermannjan/sysconf.git "${SYSCONF_DIR}"
    git -C "${SYSCONF_DIR}" remote set-url --push origin git@github.com:laermannjan/sysconf.git
    log_ok "repo"
fi

pushd "${SYSCONF_DIR}" >/dev/null
if git symbolic-ref -q HEAD &>/dev/null; then
    git pull --ff-only || log_warn "git pull failed, using local state"
else
    log_skip "git pull (detached HEAD)"
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

should_skip dotfiles || source setup/dotfiles.sh
should_skip packages || source setup/packages.sh
should_skip shell    || source setup/shell.sh
should_skip system   || source setup/system.sh
should_skip ssh      || source setup/ssh.sh       # last: only interactive step

popd >/dev/null

log "Done - run 'exec fish' to pick up changes"
