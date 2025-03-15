{ lib, modulesPath, ... }:

{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  services.qemuGuest.enable = true;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.initrd.kernelModules = [ "nvme" ];
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"
  ];

  fileSystems = {
    "/" = { device = "/dev/sda2"; fsType = "ext4"; };
    "/boot" = { device = "/dev/disk/by-uuid/A3CD-8B99"; fsType = "vfat"; };
  };

  zramSwap.enable = lib.mkForce false;
  swapDevices = [{ device = "/dev/sda3"; }];

  networking = {
    defaultGateway = {
      address = "172.82.22.129";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fe80::216:3eff:fe71:5ecb";
      interface = "ens3";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces.ens3 = {
      ipv4.addresses = [{ address = "172.82.22.168"; prefixLength = 26; }];
      ipv6.addresses = [
        { address = "2602:fe2e:4:99:8d:20ff:fe6f:8869"; prefixLength = 64; }
      ];
      ipv4.routes = [{ address = "172.82.22.129"; prefixLength = 32; }];
      ipv6.routes = [{ address = "fe80::216:3eff:fe71:5ecb"; prefixLength = 128; }];
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="02:8d:20:6f:88:69", NAME="ens3"
  '';
}
