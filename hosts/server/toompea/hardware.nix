{ lib, modulesPath, ... }:

{
  services.caddy.enable = lib.mkForce false;
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [
    "ahci"
    "ehci_pci"
    "sd_mod"
    "sr_mod"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
  ];
  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  networking = {
    defaultGateway = {
      address = "185.194.53.1";
      interface = "enp6s18";
    };
    defaultGateway6 = {
      address = "2a04:6f00:4::1";
      interface = "enp6s18";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces.enp6s18 = {
      ipv4.addresses = [{ address = "185.194.53.29"; prefixLength = 24; }];
      ipv6.addresses = [
        { address = "2a04:6f00:4::a5"; prefixLength = 48; }
        { address = "fe80::722e:d3ff:fe7b:b1ba"; prefixLength = 64; }
      ];
      ipv4.routes = [{ address = "185.194.53.1"; prefixLength = 32; }];
      ipv6.routes = [{ address = "2a04:6f00:4::1"; prefixLength = 128; }];
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="70:2e:d3:7b:b1:ba", NAME="enp6s18"
  '';
}
