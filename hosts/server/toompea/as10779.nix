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

    router = {
      id = lib.blueprint.hosts.toompea.ipv4;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.toompea) ipv4 ipv6; };
      static = {
        ipv4.routes = [{ prefix = "23.161.104.0/24"; option = "reject"; }];
        ipv6.routes = [{ prefix = "2620:BE:A000::/48"; option = "reject"; }];
      };
      sessions = [
        {
          name = "xtom";
          password = "PASS_AS3204";
          type = "direct";
          neighbor = {
            asn = 3204;
            ipv4 = "185.194.53.4";
            ipv6 = "2a04:6f00:4::4";
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
          password = "PASS_AS212232";
          type = "multihop";
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.78";
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

    inherit (lib.blueprint.hosts.toompea.as10779) local;
  };
}
