# MacBook Pro 16-inch

Flake attribute: `mbp-16`

CPU: Intel Core i9-9980HK

RAM: 32GB

Storage: 2TB

## Preparation

> [!Important]
> Enable [Firmware Password](https://support.apple.com/en-us/HT204455) before getting started.

Follow macOS built-in setup tool.

Once inside the operating system, install Xcode Command Line Tools:

```shell
xcode-select --install
```

Install [Homebrew](https://brew.sh).

Sign-in to App Store (required for `nix-darwin.options.homebrew.masApps`).

## Installation

Install `nix` with [Determinate Systems Nix Installer](https://github.com/determinatesystems/nix-installer).

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

Remove generated `nix` configuration:

```shell
sudo rm /etc/nix/nix.conf
```

Start a new terminal to activate `nix`.

Activate the system:

```shell
nix --extra-experimental-features "nix-command flakes" run github:lnl7/nix-darwin -- switch --flake github:stepbrobd/dotfiles#mbp-16
```

That's it!
