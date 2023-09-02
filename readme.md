# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![FlakeHub](https://github.com/stepbrobd/dotfiles/actions/workflows/flakehub.yml/badge.svg)

Since I have other machines with no Nix, this dotfiles repo are based on pseudo-idempotent setup script and regular text based configs, repository should be in `~/.config/dotfiles` directory.

Setup instructions below are for macOS only!

## Standalone Setup

```shell
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
```

## Nix Setup

1. Install Nix with:

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

2. After installing Nix, download [Nix-Darwin](https://github.com/LnL7/nix-darwin/) and install with default config, sourcing bashrc and zshrc:

```shell
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

```shell
export PATH="/run/current-system/sw/bin:$PATH"
```

5. Add required channels:

```shell
sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
sudo -i nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
sudo -i nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo -i nix-channel --update
```

6. Rebuild:

```shell
darwin-rebuild switch --flake .#$(nix --extra-experimental-features nix-command eval --impure --raw --expr "builtins.currentSystem")
```

## License

The contents inside this repository, excluding all submodules, are licensed under the [MIT License](license.md).
Third-party file(s) and/or code(s) are subject to their original term(s) and/or license(s).
