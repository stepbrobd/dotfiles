{
  imports = [
    ./hardware.nix

    ./as10779.nix
    ./home-assistant.nix
    ./time.nix
    ./vaultwarden.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "b82f0f98";
    hostName = "isere"; # https://en.wikipedia.org/wiki/Isère_(river)
    domain = "sd.ysun.co";
    networkmanager.enable = true;
  };
}
