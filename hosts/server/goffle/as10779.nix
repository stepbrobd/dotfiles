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
    # FIXME: core dump, see toompea

    router = {
      id = "66.135.21.33";
      secret = config.sops.secrets.bgp.path;
      source = {
        inherit (lib.blueprint.hosts.goffle) ipv4 ipv6;
        explicit = true;
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
          password = "PASS_AS212232";
          type = "multihop";
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.51";
            ipv6 = "2a0c:2f07:9459::b7";
          };
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

    inherit (lib.blueprint.hosts.goffle.as10779) local peers;
  };
}
