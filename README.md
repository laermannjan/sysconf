# sysconf

```sh
# on mac
xcode-select --install

curl -fsSL https://mise.run | sh
~/.local/bin/mise bootstrap --from https://github.com/laermannjan/sysconf --from-dir ~/sysconf

# Do not pipe `curl` into `bash` as the script won't run in interactive mode and will skip setup prompts.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
