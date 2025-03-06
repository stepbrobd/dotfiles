{ lib, ... }:

{ config, ... }:


let
  cfg = config.services.as10779;

  decision = (lib.types.submodule {
    options = {
      interface = {
        local = lib.mkOption {
          type = lib.types.str;
          description = "local interface name";
        };
        route = lib.mkOption {
          type = lib.types.str;
          description = "route interface name (the interface name on peers announcing our prefixes)";
        };
      };

      ipv4 = {
        address = lib.mkOption {
          type = lib.types.str;
          description = "IPv4 address to use on local interface";
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          description = "default gateway to use";
        };
      };

      ipv6 = {
        address = lib.mkOption {
          type = lib.types.str;
          description = "IPv6 address to use on local interface";
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          description = "default gateway to use";
        };
      };
    };
  });
in
{
  options.services.as10779 = {
    enable = lib.mkEnableOption "AS10779";

    asn = lib.mkOption {
      type = lib.types.int;
      default = 10779;
      description = "ASN";
    };

    router = {
      id = lib.mkOption {
        type = lib.types.str;
        description = "router ID";
      };

      scantime = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "scan time";
      };

      secret = lib.mkOption {
        type = lib.types.path;
        description = "path to secret (imported via `include`)";
      };

      kernel = {
        ipv4 = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "kernel4";
            description = "name of IPv4 kernel protocol";
          };
          import = lib.mkOption {
            type = lib.types.str;
            default = "import all;";
            description = "import option";
          };
          export = lib.mkOption {
            type = lib.types.str;
            default = ''export where proto = "${cfg.router.static.ipv4.name}";'';
            description = "export option";
          };
        };
        ipv6 = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "kernel6";
            description = "name of IPv6 kernel protocol";
          };
          import = lib.mkOption {
            type = lib.types.str;
            default = "import all;";
            description = "import option";
          };
          export = lib.mkOption {
            type = lib.types.str;
            default = ''export where proto = "${cfg.router.static.ipv6.name}";'';
            description = "export option";
          };
        };
      };

      static = {
        ipv4 = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "static4";
            description = "name of IPv4 static protocol";
          };
          prefixes = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ "23.161.104.0/24" ];
            description = "IPv4 prefixes to announce";
          };
        };
        ipv6 = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "static6";
            description = "name of IPv6 static protocol";
          };
          prefixes = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ "2620:BE:A000::/48" ];
            description = "IPv6 prefixes to announce";
          };
        };
      };

      sessions = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "name of BGP neighbor";
            };

            password = lib.mkOption {
              type = lib.types.str;
              description = "key of BGP session password in the environment file";
            };

            type = lib.mkOption {
              type = lib.types.enum [ "direct" "multihop" ];
              description = "connection type";
            };

            neighbor = {
              asn = lib.mkOption {
                type = lib.types.int;
                description = "ASN of BGP neighbor";
              };
              ipv4 = lib.mkOption {
                type = lib.types.str;
                description = "IPv4 of BGP neighbor";
              };
              ipv6 = lib.mkOption {
                type = lib.types.str;
                description = "IPv6 of BGP neighbor";
              };
            };

            import = {
              ipv4 = lib.mkOption {
                type = lib.types.str;
                default = "import none;";
                description = "IPv4 import option";
              };
              ipv6 = lib.mkOption {
                type = lib.types.str;
                default = "import none;";
                description = "IPv6 import option";
              };
            };

            export = {
              ipv4 = lib.mkOption {
                type = lib.types.str;
                default = "export all;";
                description = "IPv4 export option";
              };
              ipv6 = lib.mkOption {
                type = lib.types.str;
                default = "export all;";
                description = "IPv6 export option";
              };
            };
          };
        });
      };
    };

    local = lib.mkOption {
      type = decision;
      description = "local routing decision";
    };

    peers = lib.mkOption {
      type = lib.types.listOf decision;
      description = "peer decisions";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { networking.firewall.allowedTCPPorts = [ 179 ]; }

    {
      services.bird.enable = true;
      services.bird.checkConfig = false;
      services.bird.config = ''
        include "${cfg.router.secret}";

        router id ${cfg.router.id};

        protocol device {
          scan time ${lib.toString cfg.router.scantime};
        }

        protocol kernel ${cfg.router.kernel.ipv4.name} {
          scan time ${lib.toString cfg.router.scantime};

          learn;
          persist;

          ipv4 {
            ${cfg.router.kernel.ipv4.import}
            ${cfg.router.kernel.ipv4.export}
          };
        }

        protocol kernel ${cfg.router.kernel.ipv6.name} {
          scan time ${lib.toString cfg.router.scantime};

          learn;
          persist;

          ipv6 {
            ${cfg.router.kernel.ipv6.import}
            ${cfg.router.kernel.ipv6.export}
          };
        }

        protocol direct {
          interface "${cfg.local.interface.local}";
          ipv4;
          ipv6;
        }

        protocol static ${cfg.router.static.ipv4.name} {
          ipv4;

          ${lib.concatMapStringsSep
            "\n  "
            (prefix: ''route ${prefix} reject;'')
            cfg.router.static.ipv4.prefixes}
        }

        protocol static ${cfg.router.static.ipv6.name} {
          ipv6;

          ${lib.concatMapStringsSep
          "\n  "
            (prefix: ''route ${prefix} reject;'')
            cfg.router.static.ipv6.prefixes}
        }

        ${lib.concatMapStringsSep
        "\n\n"
        (session: ''
          protocol bgp ${session.name}4 {
            graceful restart on;

            ${session.type};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv4} as ${lib.toString session.neighbor.asn};
            password ${session.password};

            ipv4 {
              ${session.import.ipv4}
              ${session.export.ipv4}
            };
          }

          protocol bgp ${session.name}6 {
            graceful restart on;

            ${session.type};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv6} as ${lib.toString session.neighbor.asn};
            password ${session.password};

            ipv6 {
              ${session.import.ipv6}
              ${session.export.ipv6}
            };
          }'')
        cfg.router.sessions}'';
    }
    {
      boot.kernelModules = [ "dummy" ];
      systemd.network.netdevs."40-${cfg.local.interface.local}".netdevConfig = {
        Kind = "dummy";
        Name = cfg.local.interface.local;
      };
      networking.interfaces.${cfg.local.interface.local} = {
        ipv4 = {
          addresses =
            let
              split = lib.split "/" cfg.local.ipv4.address;
            in
            [{ address = lib.head split; prefixLength = lib.toInt (lib.last split); }];
        };
        ipv6 = {
          addresses =
            let
              split = lib.split "/" cfg.local.ipv6.address;
            in
            [{ address = lib.head split; prefixLength = lib.toInt (lib.last split); }];
        };
      };
    }
    {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv6.conf.default.forwarding" = 1;
      };
    }
  ]);
}
