## ⚡️ Requirements
- curl
- git
- git-lfs (optional, only necessary for **fonts**)
- ansible
- brew (only necessary on **macos**)
- flatpak (only necessary on **linux**)

> [!Important]
> On **macOS** log in to the App Store and install the command line tools first
> ```sh
> xcode-select --install
> ```

## 📦 Installation
The install script clones this repo to `~/sysconf` and runs the ansible playbook. Any arguments to the script are passed to the `ansible-playbook` command.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/ansible/install.sh)"
```

> [!Important]
> Do not pipe `curl` into `bash` as the script won't run in interactive mode and will skip setup prompts.

> [!Tip]
> The installer will not re-clone/update the repo if it already exists.
> Update manually with
> ```sh
> git pull && git lfs pull
> ```

You will be asked for
- **Vault password**: for secrets and private stuff
- **sudo** password: to store as the `BECOME` password for the ansible playbook

> [!Caution]
> If you run the playbook manually, make sure to run it from the `./ansible` subdirectory.

> [!Tip]
> You can store the vault password in e.g. `/tmp/vaulpw` and run the installer or playbook with
> ```sh
> VAULT_PASSWORD_FILE=/tmp/vaultpw ~/sysconf/ansible/install.sh
> ```
> Useful, when the playbook is failing and you're trying to debug.

## Post-installation
1. On **macOS** you need to disable the window switcher in `Settings > Keyboard > Keyboard Shortcuts > Keyboard > Move focus to next window`, so the WezTerm workspace shortcuts **CMD+`** works

## 🔐 SSH Secrets
SSH secrets are encrypted using `ansible-vault` and a vault password in addition to the keys' native passwords.

To update these secrets create a file containing the vault password, e.g. at `/tmp/vaultpw`,

then run the update script

```sh
VAULT_PASSWORD_FILE=/tmp/vaultpw ~/sysconf/ansible/update-secrets.sh
```

> [!Caution]
> Never commit unencrypted ssh stuff here. Encrypted files always end in `.vault` and their first line reads `$ANSIBLE_VAULT;...`

> [!Note]
> There are other vault encrypted files in this repo, which you might want to update, the script only takes care of a few ssh files.
