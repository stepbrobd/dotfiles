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
        primary = "eth0";
      };
      ipv4.addresses = [
        "23.161.104.132/32" # unicast
        "23.161.104.17/32" # personal site anycast
        "44.32.189.0/24" # 44net anycast test
      ];
      ipv6.addresses = [
        "2620:be:a000::23:161:104:132/128" # unicast
        "2620:be:a000::23:161:104:17/128" # personal site anycast
      ];
    };

    router = {
      id = lib.blueprint.hosts.butte.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.butte) ipv4 ipv6; };
      static = {
        ipv4.routes = [
          { prefix = "23.161.104.0/24"; option = "reject"; }
          { prefix = "44.32.189.0/24"; option = "reject"; }
        ];
        ipv6.routes = [{ prefix = "2620:be:a000::/48"; option = "reject"; }];
      };
      sessions = [
        {
          name = "virtua1";
          password = "PASS_AS35661";
          type = { ipv4 = "multihop"; ipv6 = "multihop"; };
          neighbor = {
            asn = 35661;
            ipv4 = "172.16.0.121";
            ipv6 = "2a0d:e680:0::b:1";
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
          name = "virtua2";
          password = "PASS_AS35661";
          type = { ipv4 = "multihop"; ipv6 = "multihop"; };
          neighbor = {
            asn = 35661;
            ipv4 = "172.16.0.122";
            ipv6 = "2a0d:e680:0::b:2";
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
          type = { ipv4 = "multihop"; ipv6 = "multihop"; };
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.75";
            ipv6 = "2a0c:2f07:9459::b6";
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
