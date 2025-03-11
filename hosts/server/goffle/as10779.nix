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
      interface.local = "dummy0";
      ipv4.address = "23.161.104.129/32";
      ipv6.address = "2620:be:a000::23:161:104:129/128";
    };

    router = {
      id = lib.blueprint.hosts.goffle.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.goffle) ipv4 ipv6; };
      static = {
        ipv4.routes = [{ prefix = "23.161.104.0/24"; option = "reject"; }];
        ipv6.routes = [{ prefix = "2620:be:a000::/48"; option = "reject"; }];
      };
      sessions = [
        {
          name = "vultr";
          password = "PASS_AS64515";
          type = "multihop";
          neighbor = {
            asn = 64515;
            ipv4 = "169.254.169.254";
            ipv6 = "2001:19f0:ffff::1";
          };
          import = {
            ipv4 = "import all;";
            ipv6 = "import all;";
          };
          export = {
            ipv4 = ''export where proto = "${cfg.router.static.ipv4.name}";'';
            ipv6 = ''export where proto = "${cfg.router.static.ipv6.name}";'';
          };
        }
        {
          name = "bgptools";
          password = null;
          type = "multihop";
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.78";
            ipv6 = "2a0c:2f07:9459::b4";
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
