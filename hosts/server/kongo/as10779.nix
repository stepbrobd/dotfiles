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

  services.as10779 = {
    enable = true;

    local = {
      hostname = config.networking.hostName;
      interface = {
        local = "dummy0";
        primary = "enp1s0";
      };
      ipv4.addresses = [
        "23.161.104.130/32" # unicast
        "23.161.104.17/32" # personal site anycast
        # "44.32.189.0/24" # 44net anycast test
      ];
      ipv6.addresses = [
        "2602:f590:0::23:161:104:130/128" # unicast
        "2602:f590:0::23:161:104:17/128" # personal site anycast
      ];
    };

    router = {
      id = lib.blueprint.hosts.kongo.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.kongo) ipv4 ipv6; };
      static =
        let
          option = lib.trim ''
            reject {
                # geotag
                bgp_community.add((20473, 23)); # Tokyo
                bgp_community.add((20473, 26)); # Soul
                # metric 0
                bgp_large_community.add((20473, 6009, 2914));  # NTT
                bgp_large_community.add((20473, 6009, 17676)); # SoftBank
                # prepend 1x
                bgp_large_community.add((20473, 6001, 3320)); # DTAG
                # prepend 2x
                bgp_large_community.add((20473, 6002, 701));  # Verizon
                bgp_large_community.add((20473, 6002, 1299)); # Arelion
                bgp_large_community.add((20473, 6002, 3491)); # PCCW
                bgp_large_community.add((20473, 6002, 6830)); # Liberty Global
                # prepend 3x
                bgp_large_community.add((20473, 6003, 174));  # Cogent
                bgp_large_community.add((20473, 6003, 1221)); # Telstra
                bgp_large_community.add((20473, 6003, 3356)); # Level3
                bgp_large_community.add((20473, 6003, 4826)); # Vocus
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
          name = "vultr";
          password = "PASS_AS64515";
          type = { ipv4 = "multihop"; ipv6 = "multihop"; };
          neighbor = {
            asn = 64515;
            ipv4 = "169.254.169.254";
            ipv6 = "2001:19f0:ffff::1";
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
            ipv6 = "2a0c:2f07:9459::b18";
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
