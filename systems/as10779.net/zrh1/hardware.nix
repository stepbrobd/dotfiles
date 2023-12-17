{ modulesPath
, ...
}:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
      kernelModules = [ "nvme" ];
    };
  };

  fileSystems = {
    "/" = { device = "/dev/sda1"; fsType = "ext4"; };
    "/boot" = { device = "/dev/disk/by-uuid/D0F3-B58A"; fsType = "vfat"; };
  };
}
