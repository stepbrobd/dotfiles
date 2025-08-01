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
  boot.kernelModules = [ "hci_uart" "btbcm" "bluetooth" "btsdio" "brcmfmac" ];

  boot.kernelParams = lib.mkForce [
    "8250.nr_uarts=11"
    "console=ttyAMA10,115200"
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
      # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
      options = {
        # https://www.raspberrypi.com/documentation/computers/config_txt.html#enable_uart
        # in conjunction with `console=serial0,115200` in kernel command line (`cmdline.txt`)
        # creates a serial console, accessible using GPIOs 14 and 15 (pins 
        #  8 and 10 on the 40-pin header)
        enable_uart = {
          enable = true;
          value = true;
        };
        # https://www.raspberrypi.com/documentation/computers/config_txt.html#uart_2ndstage
        # enable debug logging to the UART, also automatically enables 
        # UART logging in `start.elf`
        uart_2ndstage = {
          enable = true;
          value = true;
        };
      };

      # Base DTB parameters
      # https://github.com/raspberrypi/linux/blob/a1d3defcca200077e1e382fe049ca613d16efd2b/arch/arm/boot/dts/overlays/README#L132
      base-dt-params = {
        # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#enable-pcie
        pciex1 = {
          enable = true;
          value = "on";
        };
        # PCIe Gen 3.0
        # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0
        pciex1_gen = {
          enable = true;
          value = "3";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
