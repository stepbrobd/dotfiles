{ config
, lib
, pkgs
, ...
}:

{
  time.timeZone = "America/New_York";

  networking = {
    hostName = "mbp-16";
    localHostName = "Yifeis-MacBook-Pro-16";
    # computerName = "Yifei\'s MacBook Pro 16\"";
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
}
