{ lib }:

# bruh i'm not using `evalModules` here
let
  newUser =
    { userName # e.g. "ysun"
    , fullName # e.g. "Yifei Sun"
    , keys     # e.g. [ "ssh-ed25519 ..." ]
    }: {
      name = userName;
      description = fullName;
      openssh.authorizedKeys.keys = keys;
    };

  newHost =
    { hostName # e.g. "bachtel"
    , domain # e.g. "as10779.net"
    , platform # e.g. "x86_64-linux"
    , os # e.g. "darwin" or "nixos"
    , provider # e.g. "aws", "garnix", "hetzner", "owned", "ssdnodes", "vultr"
    , type # e.g. "laptop", "server"
    }: { };
in
{
  users.ysun = newUser {
    userName = "ysun";
    fullName = "Yifei Sun";
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC" # framework
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw" # macbook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQCjwNmB60FQhDncIyX/wCRAPIlLD5KLAGrgAdt4xGw" # servercat
    ];
  };

  # laptops
  hosts.framework = { };
  hosts.macbook = { };

  # servers
  hosts.bachtel = newHost {
    hostName = "bachtel";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "aws";
    type = "server";
  };

  hosts.lagern = newHost {
    hostName = "lagern";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "aws";
    type = "server";
  };

  hosts.odake = newHost {
    hostName = "odake";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "ssdnodes";
    type = "server";
  };

  hosts.walberla = newHost {
    hostName = "walberla";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "hetzner";
    type = "server";
  };
}
