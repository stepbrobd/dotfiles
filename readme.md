# Dotfiles

Inspired by [caarlos0/dotfiles.nix](https://github.com/caarlos0/dotfiles.nix).

Dotfiles with pseudo-idempotent setup script, repository should be in `~/.config/dotfiles` directory.

Setup instructions below are for MacOS only!

## Standalone Setup

```shell
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
```

## Nix Setup

1. Install Nix with:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

2. After installing Nix, download [Nix-Darwin](https://github.com/LnL7/nix-darwin/) and install with default config, sourcing bashrc and zshrc:

```bash
export EDITOR=vim && sudo rm /etc/nix/nix.conf && nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer && ./result/bin/darwin-installer
```

3. Change `~/.nixpkgs/darwin-configuration.nix` to follow:

```nix
{ config, pkgs, ... }:

{
  services.nix-daemon.enable = true;
}
```

4. Add `/run/current-system/sw/bin` to `$PATH`:

```bash
export PATH="/run/current-system/sw/bin:$PATH"
```

5. Add required channels:

```bash
sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
sudo -i nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
sudo -i nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
```

6. Rebuild:

```bash
darwin-rebuild switch --flake .#$(nix --extra-experimental-features nix-command eval --impure --raw --expr "builtins.currentSystem")
```

## License

This repository content excluding all submodules is licensed under the [MIT License](license.md), third-party code are subject to their original license.
