{ lib, ... }:

{ config, ... }:

let
  cfg = config.networking.vxlan;
in
{
  options.networking.vxlan = {
    description = '''';
    default = { };
    type = null; # TODO
  };

  config = {
    # TODO:fold over config
    # should open all dest ports
    networking.firewall.allowedUDPPorts = lib.optional (lib.length (lib.attrNames cfg) > 0) 4789;

    # TODO: parameterize ip/ip6 based on saddr (if `:` present in string)
    networking.firewall.extraInputRules = ''
      ip saddr 1.1.1.1 udp dport 4789 accept
    '';

    # TODO: map attr over cfg
    systemd.network = {
      networks."45-vx0" = {
        name = "vx0";
        address = [ "100.66.33.17/22" "2a0e:8f01:1000:9::111/64" ];
      };
      netdevs."45-vx0" = {
        netdevConfig = {
          Name = "vx0";
          Kind = "vxlan";
        };
        vxlanConfig = {
          VNI = 9559;
          Local = lib.blueprint.hosts.kongo.ipv4;
          Remote = "156.231.102.211";
          DestinationPort = 4789;
          Independent = true;
        };
      };
    };
  };
}
