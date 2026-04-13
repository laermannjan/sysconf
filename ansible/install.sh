#!/usr/bin/env bash

set -euo pipefail

SYSCONF_DIR="${HOME}/sysconf"
SYSCONF_REPO_HTTPS="https://github.com/laermannjan/sysconf.git"
SYSCONF_REPO_SSH="git@github.com:laermannjan/sysconf.git"

if [[ ! -d "${SYSCONF_DIR}" ]]; then
    git clone ${SYSCONF_REPO_HTTPS} "${SYSCONF_DIR}"
    # make ssh the primary, keep https so we can fetch updates before ssh keys are installed
    git -C "${SYSCONF_DIR}" remote set-url --push origin "${SYSCONF_REPO_SSH}"
fi

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if ! command -v uv &> /dev/null; then
    echo "uv not found. Installing via brew..."
    brew install uv
fi

if ! command -v ansible &> /dev/null; then
    echo "Ansible not found. Installing via uv..."
    uv tool install ansible-core --with bcrypt
fi

pushd "${SYSCONF_DIR}"
ansible-galaxy install -r ansible/requirements.yml &>/dev/null
ansible-playbook ansible/playbook.yml "$@"
popd

echo "Done. Invoking fish shell. You should probably reboot now."
exec fish
