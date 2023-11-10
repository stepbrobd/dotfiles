{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NixOS";
      fsType = "ext4";
    };

  swapDevices = [ ];
}
