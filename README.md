# Sytem Configurations & Dotfiles

These are the system configurations for my NixOS, macOS, and WSL hosts.
They also contain the user configurations for various customizable programs (dotfiles).

They are organized and managed by [Nix](https://nixos.org), so some of the configuration may be difficult to translate to
non-Nix managed systems. Dotfiles that I might tweak frequently, I do usually keep in their original format.

## Installation
Click [here](docs/install.md) for detailed installation instructions.

## Flake Templates
Use the [templates](./templates/) as flakes to start new projects.
```bash
nix flake init --template github:laermannjan/dotfiles#rust
```
