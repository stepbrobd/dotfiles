{
  imports = [
    ./hardware.nix

    # ./plausible.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC'' ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "f068ae2b";
    hostName = "toompea"; # https://en.wikipedia.org/wiki/Toompea
    domain = "as10779.net";
  };
}
