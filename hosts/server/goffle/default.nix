{
  imports = [
    ./hardware.nix

    # ./as10779.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC'' ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a276fa18";
    hostName = "goffle"; # https://en.wikipedia.org/wiki/Goffle_Hill
    domain = "as10779.net";
  };
}
