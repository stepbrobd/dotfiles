{ lib, ... }:

{ config, ... }:

let
  cfg = config.networking.vxlans;
in
{
  options.networking.vxlans = lib.mkOption {
    description = '''';
    default = { };
    type = with lib.types; attrsOf (submodule {
      options = {
        vni = lib.mkOption {
          type = lib.types.int;
          description = "VxLAN network identifier";
        };
        local = lib.mkOption {
          type = lib.types.str;
          description = "Local IP address";
        };
        remote = lib.mkOption {
          type = lib.types.str;
          description = "Remote IP address";
        };
        port = lib.mkOption {
          type = lib.types.int;
          description = "UDP port";
        };
        address = lib.mkOption {
          type = with lib.types; listOf str;
          description = "IP address(es)";
        };
      };
    });
  };

  config = {
    systemd.network = lib.mkMerge (
      lib.flip lib.mapAttrsToList cfg (
        name: vxlan: {
          networks."45-${name}" = {
            inherit name;
            address = vxlan.address;
          };
          netdevs."45-${name}" = {
            netdevConfig = {
              Name = name;
              Kind = "vxlan";
            };
            vxlanConfig = {
              VNI = vxlan.vni;
              Local = vxlan.local;
              Remote = vxlan.remote;
              DestinationPort = vxlan.port;
              Independent = true;
              MacLearning = true;
            };
          };
        }
      )
    );

    networking.firewall.allowedUDPPorts = lib.optionals
      (cfg != { })
      (lib.map (vxlan: vxlan.port) (lib.attrValues cfg));

    networking.firewall.extraInputRules = lib.concatStringsSep "\n  " (lib.map
      (vxlan: "${if (lib.hasInfix ":" vxlan.local) then "ip6" else "ip"} saddr ${vxlan.local} udp dport ${lib.toString vxlan.port} accept")
      (lib.attrValues cfg));

    networking.firewall.extraReversePathFilterRules = lib.concatStringsSep "\n  " (lib.map
      (vxlan: (lib.concatStringsSep "\n  " (lib.map
        (addr:
          "${if (lib.hasInfix ":" addr) then "ip6" else "ip"} saddr ${addr} accept"
        )
        vxlan.address)))
      (lib.attrValues cfg));
  };
}
