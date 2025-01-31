#!/usr/bin/env bash

[ ! -f "${VAULT_PASSWORD_FILE}" ] && echo "ERROR: Ansible vault password file not found! Create one with the vault password and specify \$VAULT_PASSWORD_FILE" 1>&2 && exit 1

for file in "~/.ssh/config" "~/.ssh/id_ed25519.alcemy" "~/.ssh/id_ed25519.alcemy.pub" "~/.ssh/id_ed25519.personal" "~/.ssh/id_ed25519.personal.pub"; do
    src="${file/#~/$HOME}"
    dest="${HOME}/sysconf/config/ssh/$(basename "${src}").vault"
    ansible-vault encrypt "${src}" --output ${dest} --vault-password-file "${VAULT_PASSWORD_FILE}"
done
