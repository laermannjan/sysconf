#!/usr/bin/env bash

set -euo pipefail

PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"

SYSCONF_DIR="${SYSCONF_DIR:-${HOME}/sysconf}"

has() { command -v "$1" &> /dev/null || { echo "Missing $1..."; return 1; }; }

if [[ -z "${NONINTERACTIVE:-}" && ! -d "${SYSCONF_DIR}" ]]; then
    git clone https://github.com/laermannjan/sysconf.git "${SYSCONF_DIR}"
    # make ssh the primary, keep https so we can fetch updates before ssh keys are installed
    git -C "${SYSCONF_DIR}" remote set-url --push origin git@github.com:laermannjan/sysconf.git
fi

has brew || NONINTERACTIVE="${NONINTERACTIVE:-}" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(brew shellenv)"

has uv || brew install uv
has ansible || uv tool install ansible-core --with bcrypt

pushd "${SYSCONF_DIR}"
ansible-galaxy install -r ansible/requirements.yml &>/dev/null
ansible-playbook ansible/playbook.yml -i localhost, "$@"
popd

if [[ -z "${NONINTERACTIVE:-}" ]]; then
    echo "Done. You should probably reboot now."
    exec fish
fi
