{ config
, lib
, pkgs
, ...
}:

{
  hardware.enableAllFirmware = lib.mkDefault true;
  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

  # setup required:
  # https://github.com/nix-community/lanzaboote
  # 1. check for secure boot support: bootctl status
  # 2. turn off secure boot on host BIOS settings
  # 3. create keys (/etc/secureboot): sudo sbctl create-keys
  # 4. check status (*bzImage.efi are not signed): sudo sbctl verify
  # 5. turn on secure boot and put it in setup mode
  # 6. enroll keys: sudo sbctl enroll-keys --microsoft
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

  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          device = "/dev/disk/by-label/Boot";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        NixOS = {
          device = "/dev/disk/by-label/NixOS";
          end = "-64G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        Swap = {
          device = "/dev/disk/by-label/Swap";
          size = "100%";
          content = {
            type = "swap";
            randomEncryption = true;
            resumeDevice = true;
          };
        };
      };
    };
  };

  # fileSystems = {
  #   "/boot" = {
  #     device = "/dev/disk/by-label/Boot";
  #     fsType = "vfat";
  #   };
  #   "/" = {
  #     device = "/dev/disk/by-label/NixOS";
  #     fsType = "ext4";
  #   };
  # };

  # swapDevices = [{ device = "/dev/disk/by-label/Swap"; }];

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
