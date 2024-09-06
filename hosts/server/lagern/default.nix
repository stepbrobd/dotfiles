{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    # ./bird2.nix
    ./caddy.nix
    ./plausible.nix
    # ./vaultwarden.nix
    # ./ysun.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/UTC";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "d9ee6f7a";
    hostName = "lagern"; # https://en.wikipedia.org/wiki/L%C3%A4gern
    domain = "as10779.net";
  };

  environment.systemPackages = with pkgs; [
    cacert

    coreutils
    inetutils
    dnsutils

    direnv
    nix-direnv
    vim
    git
    curl
    wget
  ];

  users.mutableUsers = false;
}
