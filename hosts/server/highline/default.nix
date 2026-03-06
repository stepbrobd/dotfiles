{ inputs, ... }:

{
  imports = [
    ./hardware.nix

    ./as10779.nix
    inputs.self.nixosModules.anycast
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a9df2efe";
    hostName = "highline"; # https://en.wikipedia.org/wiki/High_Line
    domain = "as10779.net";
  };
}
