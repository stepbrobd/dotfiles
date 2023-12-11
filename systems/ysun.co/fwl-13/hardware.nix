{ config
, lib
, pkgs
, modulesPath
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
  # boot.zfs.enableUnstable = true;
  # boot.zfs.forceImportRoot = false;
  # boot.zfs.allowHibernation = true;
  boot.supportedFilesystems = [ "zfs" ];
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
  services.tlp = {
    enable = true;
    settings = {
      # run `tlp fullcharge` to charge to 100%
      STOP_CHARGE_THRESH_BAT0 = 70;
      START_CHARGE_THRESH_BAT0 = 75;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    };
  };
  services.thermald.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  # services.auto-cpufreq = {
  #   enable = true;
  #   # governor: powersave, ondemand, performance
  #   # turbo: never, always, auto
  #   settings = {
  #     battery = {
  #       governor = "powersave";
  #       turbo = "never";
  #     };
  #     charger = {
  #       governor = "performance";
  #       turbo = "auto";
  #     };
  #   };
  # };

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # fingerprint
  services.fprintd = {
    enable = true;
    # https://knowledgebase.frame.work/en_us/updating-fingerprint-reader-firmware-on-linux-for-13th-gen-and-amd-ryzen-7040-series-laptops-HJrvxv_za
    # tod.enable = true;
    # tod.driver = pkgs.libfprint-2-tod1-goodix;
  };
}
