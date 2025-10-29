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
    , type # e.g. "laptop", "desktop", "server", "rpi"
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaMDj2MpMGwDcUfDcfNHb9UR7gA5Pgtt4EPyC+1OkBP" # xps
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw" # macbook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQCjwNmB60FQhDncIyX/wCRAPIlLD5KLAGrgAdt4xGw" # servercat
    ];
  };

  # laptops
  hosts.framework = { };
  hosts.macbook = { };

  # servers
  hosts.butte = newHost {
    hostName = "butte";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "virtua";
    type = "server";
    ipv4 = "185.234.100.120";
    ipv6 = "2a07:8dc0:1c:0:48:f1ff:febe:1c6";
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

  hosts.isere = newHost {
    hostName = "isere";
    domain = "as10779.net";
    platform = "aarch64-linux";
    os = "nixos";
    provider = "owned";
    type = "rpi";
    ipv4 = null;
    ipv6 = null;
  };

  hosts.highline = newHost {
    hostName = "highline";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "neptune";
    type = "server";
    ipv4 = "172.82.22.183";
    ipv6 = "2602:fe2e:4:b2:fd:87ff:fe11:53cb";
  };

  hosts.kongo = newHost {
    hostName = "kongo";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "vultr";
    type = "server";
    ipv4 = "45.32.59.137";
    ipv6 = "2001:19f0:7002:0327:5400:05ff:febb:599b";
  };

  hosts.lagern = newHost {
    hostName = "lagern";
    domain = "as10779.net";
    platform = "x86_64-linux";
    os = "nixos";
    provider = "aws";
    type = "server";
    ipv4 = "16.62.113.214";
    ipv6 = "2a05:d019:b00:b6f0:6981:b7c5:ff97:9eea";
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

  prefixes = {
    experimental = {
      ipv4 = [ ];
      ipv6 = lib.map
        (prefix: {
          inherit prefix;
          option = lib.trim ''
            reject {
                bgp_path.prepend(18932);
              }
          '';
        })
        [ "2602:f590:a::/48" "2602:f590:b::/48" "2602:f590:c::/48" ];
    };
  };
}
