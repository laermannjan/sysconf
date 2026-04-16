#!/usr/bin/env bash

set -euo pipefail

PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"

SYSCONF_DIR="${SYSCONF_DIR:-${HOME}/sysconf}"

has() { command -v "$1" &> /dev/null || { echo "Missing $1..."; return 1; }; }

# On Linux, brew requires git and build tools to be installed via system package manager
if [[ "$(uname -s)" == "Linux" ]] && ! has git; then
    if has apt-get; then
        sudo apt-get update -y && sudo apt-get install -y build-essential curl file git
    elif has dnf; then
        sudo dnf install -y curl file git gcc-c++ make procps-ng
    fi
fi

has brew || NONINTERACTIVE="${NONINTERACTIVE:-}" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(brew shellenv)"
has uv || brew install uv
has ansible || uv tool install ansible-core --with bcrypt

if [[ -z "${NONINTERACTIVE:-}" && ! -d "${SYSCONF_DIR}" ]]; then
    git clone https://github.com/laermannjan/sysconf.git "${SYSCONF_DIR}"
    # make ssh the primary, keep https so we can fetch updates before ssh keys are installed
    git -C "${SYSCONF_DIR}" remote set-url --push origin git@github.com:laermannjan/sysconf.git
fi

pushd "${SYSCONF_DIR}"
git pull --ff-only || echo "Warning: could not fast-forward, continuing with local state."
ansible-galaxy install -r ansible/requirements.yml &>/dev/null
ansible-playbook ansible/playbook.yml -i localhost, "$@"
popd

echo "Done. Start a new shell or run 'exec fish' to pick up changes."
