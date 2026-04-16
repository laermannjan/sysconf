## ⚡️ Requirements

The bootstrap script handles almost everything (brew, git, uv, ansible). You just need curl and bash.

**macOS** - already available, nothing to do.

**Debian/Ubuntu:**
```sh
sudo apt-get install -y curl
```

**Fedora:**
```sh
sudo dnf install -y curl
```

## 📦 Installation
The bootstrap script clones this repo to `~/sysconf` and runs the ansible playbook. Any arguments to the script are passed to the `ansible-playbook` command.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/sysconf.sh)"
```

> [!Important]
> Do not pipe `curl` into `bash` as the script won't run in interactive mode and will skip setup prompts.

> [!Tip]
> The script will not re-clone/update the repo if it already exists.
> Update manually with
> ```sh
> git pull
> ```

You will be asked for
- **sudo** password: to store as the `BECOME` password for the ansible playbook

> [!Caution]
> If you run the playbook manually, make sure to run it from the `./ansible` subdirectory.

## Post-installation
1. On **macOS** you need to disable the window switcher in `Settings > Keyboard > Keyboard Shortcuts > Keyboard > Move focus to next window`, so the WezTerm workspace shortcuts **CMD+`** works

