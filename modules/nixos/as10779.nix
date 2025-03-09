{ lib, ... }:

{ config, pkgs, ... }:


let
  cfg = config.services.as10779;

  routeType = lib.types.submodule {
    options = {
      prefix = lib.mkOption {
        type = lib.types.str;
        description = "prefix to announce";
      };
      option = lib.mkOption {
        type = lib.types.str;
        description = "option";
      };
    };
  };

  decisionType = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "hostname";
      };

      interface = {
        local = lib.mkOption {
          type = lib.types.str;
          description = "local interface name";
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
        upstream = lib.mkOption {
          type = lib.types.str;
          description = "upstream IPv4 address";
        };
        tailscale = lib.mkOption {
          type = lib.types.str;
          description = "tailscale IPv4 address";
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
        upstream = lib.mkOption {
          type = lib.types.str;
          description = "upstream IPv6 address";
        };
        tailscale = lib.mkOption {
          type = lib.types.str;
          description = "tailscale IPv6 address";
        };
      };
    };
  };
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

      source = {
        ipv4 = lib.mkOption {
          type = lib.types.str;
          description = "IPv4 source address";
        };
        ipv6 = lib.mkOption {
          type = lib.types.str;
          description = "IPv6 source address";
        };
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
            default = "import none;";
            description = "import option";
          };
          export = lib.mkOption {
            type = lib.types.str;
            default = "export all;";
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
            default = "import none;";
            description = "import option";
          };
          export = lib.mkOption {
            type = lib.types.str;
            default = "export all;";
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
          routes = lib.mkOption {
            type = with lib.types; listOf routeType;
            description = "IPv4 prefixes to announce and their corresponding options";
          };
        };
        ipv6 = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "static6";
            description = "name of IPv6 static protocol";
          };
          routes = lib.mkOption {
            type = with lib.types; listOf routeType;
            description = "IPv6 prefixes to announce and their corresponding options";
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

            addpath = lib.mkOption {
              type = lib.types.enum [ "switch" "rx" "tx" "off" ];
              default = "off";
              description = "BGP Add-Path extension";
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
      type = decisionType;
      description = "local routing decision";
    };

    peers = lib.mkOption {
      type = lib.types.listOf decisionType;
      description = "peer decisions";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { networking.firewall.allowedTCPPorts = [ 179 ]; }

    {
      services.bird.enable = true;
      services.bird.checkConfig = false;
      services.bird.package = pkgs.bird2;
      services.bird.config = ''
        include "${cfg.router.secret}";

        router id ${cfg.router.id};

        protocol device {
          scan time ${lib.toString cfg.router.scantime};
        }

        protocol direct {
          interface "${cfg.local.interface.local}";
          ipv4;
          ipv6;
        }

        protocol kernel ${cfg.router.kernel.ipv4.name} {
          scan time ${lib.toString cfg.router.scantime};
          kernel table ${lib.toString cfg.asn};

          learn;
          persist;

          ipv4 {
            ${cfg.router.kernel.ipv4.import}
            ${cfg.router.kernel.ipv4.export}
          };
        }

        protocol kernel ${cfg.router.kernel.ipv6.name} {
          scan time ${lib.toString cfg.router.scantime};
          kernel table ${lib.toString cfg.asn};

          learn;
          persist;

          ipv6 {
            ${cfg.router.kernel.ipv6.import}
            ${cfg.router.kernel.ipv6.export}
          };
        }

        protocol static ${cfg.router.static.ipv4.name} {
          ipv4;

          ${lib.concatMapStringsSep
            "\n  "
            (r: ''route ${r.prefix} ${r.option};'')
            cfg.router.static.ipv4.routes}
        }

        protocol static ${cfg.router.static.ipv6.name} {
          ipv6;

          ${lib.concatMapStringsSep
          "\n  "
            (r: ''route ${r.prefix} ${r.option};'')
            cfg.router.static.ipv6.routes}
        }

        ${lib.concatMapStringsSep
        "\n\n"
        (peer: ''
          protocol bgp ${peer.hostname} {
            graceful restart on;

            multihop;
            source address ${cfg.local.ipv4.tailscale};
            local as ${lib.toString cfg.asn};
            neighbor ${peer.ipv4.tailscale} as ${lib.toString cfg.asn};

            ipv4 {
              import all;
              export where proto = "direct1";
              next hop self;
            };

            ipv6 {
              import all;
              export where proto = "direct1";
              next hop self;
            };
          }'')
          cfg.peers}

        ${lib.concatMapStringsSep
        "\n\n"
        (session: ''
          protocol bgp ${session.name}4 {
            graceful restart on;

            ${session.type};
            source address ${cfg.router.source.ipv4};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv4} as ${lib.toString session.neighbor.asn};
            password ${session.password};

            ipv4 {
              add paths ${session.addpath};
              ${session.import.ipv4}
              ${session.export.ipv4}
            };
          }

          protocol bgp ${session.name}6 {
            graceful restart on;

            ${session.type};
            source address ${cfg.router.source.ipv6};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv6} as ${lib.toString session.neighbor.asn};
            password ${session.password};

            ipv6 {
              add paths ${session.addpath};
              ${session.import.ipv6}
              ${session.export.ipv6}
            };
          }'')
        cfg.router.sessions}'';
    }
    {
      boot.kernelModules = [ "dummy" ];
      systemd.network.config.networkConfig.ManageForeignRoutes = false;

      systemd.network.netdevs."40-${cfg.local.interface.local}".netdevConfig = {
        Kind = "dummy";
        Name = cfg.local.interface.local;
      };

      systemd.network.networks."40-${cfg.local.interface.local}" = {
        name = cfg.local.interface.local;
        address = [
          cfg.local.ipv4.address
          cfg.local.ipv6.address
        ];
        routingPolicyRules = [
          {
            From = "23.161.104.0/24";
            Table = cfg.asn;
            Priority = 10000;
          }
          {
            From = "2620:BE:A000::/48";
            Table = cfg.asn;
            Priority = 10000;
          }
        ];
      };

      networking.localCommands = ''
        ${pkgs.tailscale}/bin/tailscale up --reset --ssh --advertise-exit-node --accept-routes --advertise-routes=${cfg.local.ipv4.address},${cfg.local.ipv6.address} --snat-subnet-routes=false
        ${pkgs.iptables}/bin/iptables  -t nat -A POSTROUTING -o ${config.services.tailscale.interfaceName} ! -s   23.161.104.0/24 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o ${config.services.tailscale.interfaceName} ! -s 2620:BE:A000::/48 -j MASQUERADE
      '';
    }
    {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv6.conf.default.forwarding" = 1;
      };
    }
    {
      services.prometheus = {
        exporters.bird = {
          enable = with config.services; bird.enable && prometheus.enable;
          listenAddress = "127.0.0.1";
          port = 9324;
        };
        scrapeConfigs = [
          {
            job_name = "prometheus-bird-exporter";
            static_configs = [
              { targets = [ "${with config.services.prometheus.exporters.bird; lib.toString listenAddress + ":" + lib.toString port}" ]; }
            ];
          }
          {
            job_name = "prometheus-bgptools-exporter";
            static_configs = [{ targets = [ "bgp.tools" ]; }];
            metrics_path = "/prom/1dafeced-2b12-40c0-a173-e9296ddb6df4";
          }
        ];
      };
    }
  ]);
}
