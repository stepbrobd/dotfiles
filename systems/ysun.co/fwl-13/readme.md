# Framework Laptop 13

Flake attribute: `fwl-13`

CPU: Intel Core i7-1360P
RAM: 64GB
Storage: 1TB

## Installation

Boot into minimal NixOS installer.

Switch to root user.

Format disks:

```shell
bash $(nix --extra-experimental-features "nix-command flakes" build --no-link --print-out-paths github:stepbrobd/dotfiles#nixosConfigurations.fwl-13.config.system.build.diskoScript)
```

Install:

```shell
nixos-install --flake github:stepbrobd/dotfiles#fwl-13
```
