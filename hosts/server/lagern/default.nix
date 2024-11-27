{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ./plausible.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "d9ee6f7a";
    hostName = "lagern"; # https://en.wikipedia.org/wiki/L%C3%A4gern
    domain = "as10779.net";
  };
}
