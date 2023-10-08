{ config
, lib
, pkgs
, ...
}:

{
  hardware.enableAllFirmware = lib.mkDefault true;
  services.fwupd.enable = true;

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

  imports = [ ./disko.nix ];
  boot.zfs.enableUnstable = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zpool_zroot" ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  security.tpm2 = {
    enable = true;
    tctiEnvironment.enable = true;
  };

  # power
  services.thermald.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services.auto-cpufreq = {
    enable = true;
    # governor: powersave, ondemand, performance
    # turbo: never, always, auto
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # fingerprint
  services.fprintd.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}