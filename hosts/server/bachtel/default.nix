{
  imports = [
    ./hardware.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "bd4f630f";
    hostName = "bachtel"; # https://en.wikipedia.org/wiki/Bachtel
    domain = "as10779.net";
  };
}
