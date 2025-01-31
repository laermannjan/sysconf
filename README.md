## ⚡️ Requirements
- curl
- git
- ansible
- git-lfs (optional, only necessary for fonts)
- brew (optional, only necessary on macos)

> [!Important]
> On **macOS** log in to the App Store and install the command line tools first
> ```sh
> xcode-select --install
> ```

## 📦 Installation
The install script clones this repo to `~/sysconf` and runs the ansible playbook. Any arguments to the script are passed to the `ansible-playbook` command.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/ansible/install)"
```

> [!Important]
> Do not pipe `curl` into `bash` as the script won't run in interactive mode and will skip setup prompts.

> [!Tip]
> The installer will not re-clone/update the repo if it already exists.
> Update manually with `git pull && git lfs pull`

You will be asked for
- **Vault password**: for secrets and private stuff
- **sudo** password: to store as the `BECOME` password for the ansible playbook

> [!Caution]
> If you run the playbook manually, make sure to run it from the `./ansible` subdirectory.

> [!Tip]
> You can store the vault password in e.g. `/tmp/vaulpw` and run the installer or playbook with
> ```sh
> VAULT_PASSWORD_FILE=/tmp/vaultpw ~/sysconf/ansible/install
> ```
> Useful, when the playbook is failing and you're trying to debug.

## Post-installation
1. `CMD+\`` in WezTerm might not work initially as it's could be bound to switch windows of the same app.
On **macOS** you need to disable the window switcher in `Settings > Keyboard > Keyboard Shortcuts > Keyboard > Move focus to next window`
