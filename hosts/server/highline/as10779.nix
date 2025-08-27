{ lib, config, ... }:

let
  cfg = config.services.as10779;
in
{
  sops.secrets.bgp = {
    sopsFile = ./secrets.yaml;
    mode = "440";
    owner = config.systemd.services.bird.serviceConfig.User;
    group = config.systemd.services.bird.serviceConfig.Group;
    reloadUnits = [ config.systemd.services.bird.name ];
  };

  networking.vxlans.vx0 = {
    vni = 18774;
    local = lib.blueprint.hosts.highline.ipv6;
    remote = "2a11:6c7:3::1";
    port = 4789;
    address = [ "2a11:6c7:f01:8d::2/64" ];
  };

  services.as10779 = {
    enable = true;

    local = {
      hostname = config.networking.hostName;
      interface = {
        local = "dummy0";
        primary = "ens3";
      };
      ipv4.addresses = [
        "23.161.104.129/32" # unicast
        "23.161.104.17/32" # personal site anycast
        # "44.32.189.0/24" # 44net anycast test
      ];
      ipv6.addresses = [
        "2602:f590:0::23:161:104:129/128" # unicast
        "2602:f590:0::23:161:104:17/128" # personal site anycast
      ];
    };

    router = {
      id = lib.blueprint.hosts.highline.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.highline) ipv4 ipv6; };
      static =
        let
          option = lib.trim ''
            reject {
                bgp_large_community.add((21700, 101, 2)); # customer route
                bgp_large_community.add((21700, 102, 840)); # source US
                bgp_large_community.add((21700, 103, 1)); # source NYC
                bgp_large_community.add((21700, 660, 2)); # not exported to peers
              }
          '';
        in
        {
          ipv4.routes = [
            { inherit option; prefix = "23.161.104.0/24"; }
            # { inherit option; prefix = "44.32.189.0/24"; } # stop announcing 44net for now
            { inherit option; prefix = "192.104.136.0/24"; }
          ];
          ipv6.routes = [
            { inherit option; prefix = "2602:f590::/36"; }
          ];
        };
      sessions = [
        {
          name = "neptune";
          password = null;
          type = { ipv4 = "direct"; ipv6 = "multihop"; };
          neighbor = {
            asn = 21700;
            ipv4 = "172.82.22.129";
            ipv6 = "2602:fe2e:4:80::1";
          };
          import = {
            ipv4 = "import filter ${cfg.router.rpki.ipv4.filter};";
            ipv6 = "import filter ${cfg.router.rpki.ipv6.filter};";
          };
          export = {
            ipv4 = ''export where proto = "${cfg.router.static.ipv4.name}";'';
            ipv6 = ''export where proto = "${cfg.router.static.ipv6.name}";'';
          };
        }
        {
          name = "route64";
          password = null;
          type = { ipv4 = "disabled"; ipv6 = "direct"; };
          mp = "v4 over v6";
          source = { ipv4 = null; ipv6 = "2a11:6c7:f01:8d::2"; };
          neighbor = {
            asn = 212895;
            ipv4 = null;
            ipv6 = "2a11:6c7:f01:8d::1";
          };
          import = {
            ipv4 = "import filter ${cfg.router.rpki.ipv4.filter};";
            ipv6 = "import filter ${cfg.router.rpki.ipv6.filter};";
          };
          export = {
            ipv4 = ''export where proto = "${cfg.router.static.ipv4.name}";'';
            ipv6 = ''export where proto = "${cfg.router.static.ipv6.name}";'';
          };
        }
        {
          name = "bgptools";
          password = null;
          type = { ipv4 = "disabled"; ipv6 = "multihop"; };
          mp = "v4 over v6";
          neighbor = {
            asn = 212232;
            ipv4 = null;
            ipv6 = "2a0c:2f07:9459::b14";
          };
          addpath = "tx";
          import = {
            ipv4 = "import none;";
            ipv6 = "import none;";
          };
          export = {
            ipv4 = "export all;";
            ipv6 = "export all;";
          };
        }
      ];
    };
  };
}
