{ inputs, ... }:

{
  imports = [
    ./hardware.nix

    ./as10779.nix
    inputs.self.nixosModules.anycast
    ./plausible.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "f068ae2b";
    hostName = "toompea"; # https://en.wikipedia.org/wiki/Toompea
    domain = "as10779.net";
  };
}
