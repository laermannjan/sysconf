# Apps

Run the apps with:

```bash
nix run github.com:laermannjan/sysconf#appname
# -- or (if this repo is available locally)--
nix run $SYSCONF#appname
# -- pass arguments to the apps like this:
argname=value nix run $SYSCONF#appname
```

You should try:
```bash
nix run github.com:laermannjan/sysconf#readme
```
