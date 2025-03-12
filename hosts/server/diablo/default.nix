{
  imports = [
    ./hardware.nix

    # ./as10779.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "f2ded646";
    hostName = "diablo"; # https://en.wikipedia.org/wiki/Diablo_Range
    domain = "as10779.net";
  };
}
