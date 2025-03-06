{ lib, ... }:

{ config, ... }:


let
  cfg = config.services.as10779;
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

      announce = {
        v4 = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ "23.161.104.0/24" ];
          description = "IPv4 prefixes to announce";
        };
        v6 = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ "2620:BE:A000::/48" ];
          description = "IPv6 prefixes to announce";
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
          };
        });
      };
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

        protocol kernel kernel4 {
          scan time ${lib.toString cfg.router.scantime};

          learn;
          persist;

          ipv4 {
            import none;
            export all;
          };
        }

        protocol kernel kernel6 {
          scan time ${lib.toString cfg.router.scantime};

          learn;
          persist;

          ipv6 {
            import none;
            export all;
          };
        }

        protocol static static4 {
          ipv4;

          ${lib.concatMapStringsSep
            "\n  "
            (prefix: ''route ${prefix} via "lo";'') # FIXME: create a separate interface to route traffic to our prefixes
            cfg.router.announce.v4}
        }

        protocol static static6 {
          ipv6;

          ${lib.concatMapStringsSep
            "\n  "
            (prefix: ''route ${prefix} via "lo";'') # FIXME: create a separate interface to route traffic to our prefixes
            cfg.router.announce.v6}
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
              import none;
              export where proto = "static4";
            };
          }

          protocol bgp ${session.name}6 {
            graceful restart on;

            ${session.type};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv6} as ${lib.toString session.neighbor.asn};
            password ${session.password};

            ipv6 {
              import none;
              export where proto = "static6";
            };
          }'')
        cfg.router.sessions}'';
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
