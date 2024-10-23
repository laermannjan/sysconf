# Installation

## macOS

First, install Nix:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

> [!TIP]
> Should this fail, ensure you have xcode installed `xcode-select --install`

Launch a new shell. Then switch to the macOS configuration, which will install the system and configurations and make the
`darwin-rebuild` binary available:

```bash
nix \
    --extra-experimental-features flakes \
    --extra-experimental-features nix-command \
    run nix-darwin -- switch \
    --flake github:laermannjan/sysconf#<name of darwinConfiguration; e.g. `work`>
```

> [!TIP]
>
> Should you have problems concerning the architecture of certain features not being compatible, double check that the system
> architecture of your system is the same as defined in the `darwinConiguration` (possible: `x86_64-darwin`, `aarch64-darwin`)!
> If that is the case and you still have problems, you might need to install rosetta stone:
> `/usr/sbin/softwareupdate --install-rosetta --agree-to-license`

Once installed, you can continue to update the macOS configuration locally:

```bash
darwin-rebuild switch --flake $NIXCONFDIR
```
## Restore your ssh-keys
Restore your ssh keys that you previously backed up with [melt](https://github.com/charmbracelet/melt) using the [loadkey app](../apps/loadkey.nix).
