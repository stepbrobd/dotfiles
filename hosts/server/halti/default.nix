{
  imports = [
    ./hardware.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a4c7c5aa";
    hostName = "halti";
    domain = "as10779.net";
  };
}
