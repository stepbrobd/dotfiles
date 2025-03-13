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
          description = "local interface name that will be used to assign addresses within the announced prefixes";
        };
        primary = lib.mkOption {
          type = lib.types.str;
          description = "the primary interface (assigned by hosting provider)";
        };
      };

      ipv4.address = lib.mkOption {
        type = lib.types.str;
        description = "IPv4 address to use on local interface";
      };

      ipv6.address = lib.mkOption {
        type = lib.types.str;
        description = "IPv6 address to use on local interface";
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

    local = lib.mkOption {
      type = decisionType;
      description = "local routing decision";
    };

    router = {
      id = lib.mkOption {
        type = lib.types.str;
        description = "router ID";
      };

      exit = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "is this node capable of sending outboud traffic (i.e. have BGP session or not)";
      };

      outboundGateway = {
        ipv4 = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            IPv4 address of outbound gateway if different from main interface's default gateway
            only set this if upstream provider requires it
          '';
        };
        ipv6 = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            IPv6 address of outbound gateway if different from main interface's default gateway
            only set this if upstream provider requires it
          '';
        };
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

      rpki = {
        ipv4 = {
          table = lib.mkOption {
            type = lib.types.str;
            default = "trpki4";
            description = "IPv4 RPKI table name";
          };
          filter = lib.mkOption {
            type = lib.types.str;
            default = "validated4";
            description = "IPv4 RPKI filter name";
          };
        };
        ipv6 = {
          table = lib.mkOption {
            type = lib.types.str;
            default = "trpki6";
            description = "IPv6 RPKI table name";
          };
          filter = lib.mkOption {
            type = lib.types.str;
            default = "validated6";
            description = "IPv6 RPKI filter name";
          };
        };
        retry = lib.mkOption {
          type = lib.types.int;
          default = 600;
          description = "retry time";
        };
        refresh = lib.mkOption {
          type = lib.types.int;
          default = 3600;
          description = "refresh time";
        };
        expire = lib.mkOption {
          type = lib.types.int;
          default = 7200;
          description = "expire time";
        };
        validators = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              id = lib.mkOption {
                type = lib.types.int;
                description = "id of RPKI validator (only for generating unique names)";
              };
              remote = lib.mkOption {
                type = lib.types.str;
                description = "remote address";
              };
              port = lib.mkOption {
                type = lib.types.int;
                description = "port";
              };
            };
          });
          default = [
            { id = 0; remote = "rtr.rpki.cloudflare.com"; port = 8282; }
          ];
          description = "RPKI validators";
        };
      };

      device.name = lib.mkOption {
        type = lib.types.str;
        default = "device0";
        description = "name of device protocol";
      };

      direct.name = lib.mkOption {
        type = lib.types.str;
        default = "direct0";
        description = "name of direct protocol";
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
            default = "export none;";
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
            default = "export none;";
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
              type = with lib.types; nullOr str;
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
  };

  # require nftables and tailscale
  # already imported in minimal
  # imports = with inputs.self.nixosModules; [ nftables tailscale ];

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      networking.firewall.allowedTCPPorts = lib.optional cfg.router.exit 179;
      services.bird.enable = cfg.router.exit;
      services.bird.checkConfig = false;
      services.bird.package = pkgs.bird2;
      services.bird.config = ''
        include "${cfg.router.secret}";

        router id ${cfg.router.id};

        roa4 table ${cfg.router.rpki.ipv4.table};
        roa6 table ${cfg.router.rpki.ipv6.table};

        ${lib.concatMapStringsSep
        "\n\n"
        (validator: ''
          protocol rpki rpki${lib.toString validator.id} {
            roa4 { table ${cfg.router.rpki.ipv4.table}; };
            roa6 { table ${cfg.router.rpki.ipv6.table}; };

            remote "${validator.remote}" port ${lib.toString validator.port};

            retry keep ${lib.toString cfg.router.rpki.retry};
            refresh keep ${lib.toString cfg.router.rpki.refresh};
            expire ${lib.toString cfg.router.rpki.expire};
          }'')
        cfg.router.rpki.validators}

        filter ${cfg.router.rpki.ipv4.filter} {
          if (roa_check(${cfg.router.rpki.ipv4.table}, net, bgp_path.last) = ROA_INVALID) then {
            print "Ignore RPKI invalid ", net, " for ASN ", bgp_path.last;
            reject;
          }
          accept;
        }

        filter ${cfg.router.rpki.ipv6.filter} {
          if (roa_check(${cfg.router.rpki.ipv6.table}, net, bgp_path.last) = ROA_INVALID) then {
            print "Ignore RPKI invalid ", net, " for ASN ", bgp_path.last;
            reject;
          }
          accept;
        }

        protocol device ${cfg.router.device.name} {
          scan time ${lib.toString cfg.router.scantime};
        }

        protocol direct ${cfg.router.direct.name} {
          interface "${cfg.local.interface.local}";
          ipv4;
          ipv6;
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
        (session: ''
          protocol bgp ${session.name}4 {
            graceful restart on;

            ${session.type};
            source address ${cfg.router.source.ipv4};
            local as ${lib.toString cfg.asn};
            neighbor ${session.neighbor.ipv4} as ${lib.toString session.neighbor.asn};${
              if lib.isNull session.password
              then ""
              else "\n  password ${session.password};"
            }

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
            neighbor ${session.neighbor.ipv6} as ${lib.toString session.neighbor.asn};${
              if lib.isNull session.password
              then ""
              else "\n  password ${session.password};"
            }

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
        # only needed when announced prefixes' outbound gateway is
        # different from the default gateway of the main interface
        routingPolicyRules = lib.remove { } (lib.flatten [
          (lib.optionalAttrs (lib.isString cfg.router.outboundGateway.ipv4) (lib.map
            (r: {
              From = r.prefix;
              Table = cfg.asn;
              Priority = 10000;
            })
            cfg.router.static.ipv4.routes))
          (lib.optionalAttrs (lib.isString cfg.router.outboundGateway.ipv6) (lib.map
            (r: {
              From = r.prefix;
              Table = cfg.asn;
              Priority = 10000;
            })
            cfg.router.static.ipv6.routes))
        ]);
      };

      networking.nftables.tables = {
        outbound4 = {
          name = "nat";
          family = "ip";
          content = ''
            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;
              ${lib.optionalString (! cfg.router.exit) ''ip saddr { ${lib.concatMapStringsSep ", " (r: r.prefix) cfg.router.static.ipv4.routes} } oifname "${cfg.local.interface.primary}" masquerade''}
              ip saddr != { ${lib.concatMapStringsSep ", " (r: r.prefix) cfg.router.static.ipv4.routes} } oifname { "${cfg.local.interface.primary}", "${config.services.tailscale.interfaceName}" } masquerade
            }
          '';
        };
        outbound6 = {
          name = "nat";
          family = "ip6";
          content = ''
            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;
              ${lib.optionalString (! cfg.router.exit) ''ip6 saddr { ${lib.concatMapStringsSep ", " (r: r.prefix) cfg.router.static.ipv6.routes} } oifname "${cfg.local.interface.primary}" masquerade''}
              ip6 saddr != { ${lib.concatMapStringsSep ", " (r: r.prefix) cfg.router.static.ipv6.routes} } oifname { "${cfg.local.interface.primary}", "${config.services.tailscale.interfaceName}" } masquerade
            }
          '';
        };
      };

      services.tailscale.extraSetFlags = [
        "--accept-routes"
        "--advertise-exit-node"
        "--advertise-routes=${cfg.local.ipv4.address},${cfg.local.ipv6.address}"
        "--snat-subnet-routes=false"
        "--ssh"
      ];

      networking.localCommands =
        (lib.optionalString (lib.isString cfg.router.outboundGateway.ipv4) ''
          ip -4 route replace default via ${cfg.router.outboundGateway.ipv4} table ${lib.toString cfg.asn}
        '')
        +
        (lib.optionalString (lib.isString cfg.router.outboundGateway.ipv6) ''
          ip -6 route replace default via ${cfg.router.outboundGateway.ipv6} table ${lib.toString cfg.asn}
        '');
    }
    {
      networking.tempAddresses = "disabled";
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
