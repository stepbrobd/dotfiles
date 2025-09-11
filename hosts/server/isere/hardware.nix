{ inputs, lib, ... }:

{
  imports = with inputs.rpi.nixosModules; [
    ./disko.nix
    inputs.disko.nixosModules.disko

    nixpkgs-rpi
    inputs.rpi.lib.inject-overlays

    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
    raspberry-pi-5.display-vc4
  ];

  # bluetooth
  # https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5#Bluetooth
  boot.kernelModules = [
    "hci_uart"
    "btbcm"
    "bluetooth"
    "btsdio"
    "brcmfmac"
  ];

  boot.kernelParams = lib.mkForce [
    "8250.nr_uarts=11"
    "console=tty1"
    "root=fstab"
    "loglevel=7"
    "lsm=landlock,yama,bpf"
  ];

  # https://github.com/nvmd/nixos-raspberrypi-demo/blob/2847963e7555fc412c1d0f37bb48c761e78f350d/flake.nix#L154-L160
  # Ignore partitions with "Required Partition" GPT partition attribute
  # On our RPis this is firmware (/boot/firmware) partition
  services.udev.extraRules = ''
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  # https://github.com/nvmd/nixos-raspberrypi-demo/blob/2847963e7555fc412c1d0f37bb48c761e78f350d/pi5-configtxt.nix
  hardware.raspberry-pi.config = {
    all = {
      dt-overlays.miniuart-bt = {
        enable = true;
        params = { };
      };

      base-dt-params = {
        pciex1 = {
          enable = true;
          value = "on";
        };
        pciex1_gen = {
          enable = true;
          value = "3";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
