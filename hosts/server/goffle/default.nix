{
  imports = [
    ./hardware.nix

    ./as10779.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a276fa18";
    hostName = "goffle"; # https://en.wikipedia.org/wiki/Goffle_Hill
    domain = "as10779.net";
  };
}
