{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];
  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  networking = {
    defaultGateway = {
      interface = "eth0";
      address = "77.37.125.254";
    };
    defaultGateway6 = {
      interface = "eth0";
      address = "2a02:4780:28::1";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{ address = "77.37.125.123"; prefixLength = 24; }];
        ipv6.addresses = [{ address = "2a02:4780:28:5bd::1"; prefixLength = 48; }];
        ipv4.routes = [{ address = "77.37.125.254"; prefixLength = 32; }];
        ipv6.routes = [{ address = "2a02:4780:28::1"; prefixLength = 128; }];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="5a:e8:d4:b6:82:2c", NAME="eth0"
  '';

  system.stateVersion = "25.11";
}
