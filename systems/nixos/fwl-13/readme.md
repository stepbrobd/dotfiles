# Framework Laptop 13

Flake attribute: `fwl-13`

CPU: Intel Core i7-1360P

RAM: 64GB

Storage: 1TB

## Preparation

> [!Important]
> Comment out `boot.zfs.forceImportRoot = false;` and `boot.zfs.allowHibernation = true;` if this is the system's first boot.

From [NixOS options](https://mynixos.com/nixpkgs/option/boot.zfs.forceImportRoot):

This is enabled by default for backwards compatibility purposes, but it is highly recommended to disable this option, as it bypasses some of the safeguards ZFS uses to protect your ZFS pools.

If you set this option to false and NixOS subsequently fails to boot because it cannot import the root pool, you should boot with the zfs_force=1 option as a kernel parameter (e.g. by manually editing the kernel params in grub during boot). You should only need to do this once.

Then uncomment after the system's first boot.

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
