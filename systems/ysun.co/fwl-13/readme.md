# Framework Laptop 13

Flake attribute: `fwl-13`

CPU: Intel Core i7-1360P

RAM: 64GB

Storage: 1TB

## Installation

> [!Important]
> Disable Secure Boot before getting started.

Boot into minimal NixOS installer and switch to root user.

Format disks:

```shell
bash $(nix --extra-experimental-features "nix-command flakes" build --no-link --print-out-paths github:stepbrobd/dotfiles#nixosConfigurations.fwl-13.config.system.build.diskoScript)
```

Install:

```shell
nixos-install --flake github:stepbrobd/dotfiles#fwl-13
```

It's expected to have errors related to [Lanzaboote](https://github.com/nix-community/lanzaboote) since secure boot PKI bundle is not setup.

After `nixos-install`, DO NOT reboot.

Create secure boot keys and copy them to new system:

```shell
sbctl create-keys && mv /etc/secureboot /mnt/etc
```

Run installation again:

```shell
nixos-install --flake github:stepbrobd/dotfiles#fwl-13
```

Lanzaboote should not complain this time.

Reboot into NixOS, verify secure boot with:

```shell
sbctl verify
```

It is expected that the files ending with `*-bzImage.efi` are not signed.

Restart the system, `F2` to go to boot menu.

- Administer Secure Boot > Enforce Secure Boot > Enabled

- Administer Secure Boot > Erase all Secure Boot Settings > Enabled

`F10` to save and reboot.

After logging into NixOS, enroll keys:

```shell
sbctl enroll-keys --microsoft
```

Reboot to check secure boot status:

```shell
bootctl status
```

That's it!

## Standalone Disko Setup

Usually not used, managed directly by this flake.

```shell
nix run github:nix-community/disko -- --mode disko ./disko.nix
```

See [Disko Quick Start Guide](https://github.com/nix-community/disko/blob/master/docs/quickstart.md) for details.
