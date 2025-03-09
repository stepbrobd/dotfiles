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
    , provider # e.g. "aws", "garnix", "hetzner", "owned", "ssdnodes", "vultr", "xtom"
    , type # e.g. "laptop", "server"
    , ipv4 ? null
    , ipv6 ? null
    , services ? { }
    }: {
      inherit platform os provider type; # metadata
      inherit hostName domain ipv4 ipv6; # networking
      inherit services;
      fqdn = "${hostName}.${domain}";
    };
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
  hosts.goffle = newHost {
    hostName = "goffle";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "vultr";
    type = "server";
    ipv4 = "66.135.21.33";
    ipv6 = "2001:19f0:0000:71c6:5400:05ff:fe53:5f61";
  };

  hosts.halti = newHost {
    hostName = "halti";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "garnix";
    type = "server";
    ipv4 = "37.27.181.83";
    ipv6 = null;
  };

  hosts.kongo = newHost {
    hostName = "kongo";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "vultr";
    type = "server";
    ipv4 = "64.176.58.7";
    ipv6 = "2401:c080:3800:21c4:5400:05ff:fe53:aca3";
  };

  hosts.odake = newHost {
    hostName = "odake";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "ssdnodes";
    type = "server";
    ipv4 = "209.182.234.194";
    ipv6 = "2602:ff16:14:0:1:56:0:1";
  };

  hosts.toompea = newHost {
    hostName = "toompea";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "xtom";
    type = "server";
    ipv4 = "185.194.53.29";
    ipv6 = "2a04:6f00:4::a5";
  };

  hosts.walberla = newHost {
    hostName = "walberla";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "hetzner";
    type = "server";
    ipv4 = "23.88.126.45";
    ipv6 = "2a01:4f8:c17:4b75::1";
  };
}
