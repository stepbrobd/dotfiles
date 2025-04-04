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
    vni = 9565;
    local = lib.blueprint.hosts.highline.ipv4;
    remote = "108.181.251.30";
    port = 4789;
    address = [ "100.67.69.38/22" "2a0e:8f01:1000:82::126/64" ];
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
        "2620:be:a000::23:161:104:129/128" # unicast
        "2620:be:a000::23:161:104:17/128" # personal site anycast
      ];
    };

    router = {
      id = lib.blueprint.hosts.highline.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.highline) ipv4 ipv6; };
      static = {
        ipv4.routes = [
          { prefix = "23.161.104.0/24"; option = "reject"; }
          { prefix = "44.32.189.0/24"; option = "reject"; }
        ];
        ipv6.routes = [{ prefix = "2620:be:a000::/48"; option = "reject"; }];
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
          name = "bgptools";
          password = null;
          type = { ipv4 = "multihop"; ipv6 = "multihop"; };
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.51";
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
