{ config
, lib
, pkgs
, ...
}:

{
  time.timeZone = "America/New_York";

  networking = {
    hostName = "macbook";
    localHostName = "Yifeis-MacBook-Pro";
    computerName = "Yifei's MacBook Pro";
    knownNetworkServices = [
      "Tailscale Tunnel"
      "Wi-Fi"
      "Bluetooth PAN"
      "iPhone USB"
      "Ethernet Adaptor"
      "Belkin USB-C LAN"
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
      "Thunderbolt Ethernet Slot 1"
      "Thunderbolt Ethernet Slot 2"
      "Thunderbolt Ethernet Slot 3"
      "Thunderbolt Ethernet Slot 4"
    ];
  };

  # nix.lix.enable = true;
  nix.nixbuild.enable = true;
}
