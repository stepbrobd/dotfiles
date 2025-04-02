{ lib, config, ... }:

let
  cfg = config.services.as10779;
in
{
  sops.secrets.bgp = {
    sopsFile = ./secrets.yaml;
    mode = "440";
    # owner = config.systemd.services.bird.serviceConfig.User;
    # group = config.systemd.services.bird.serviceConfig.Group;
    # reloadUnits = [ config.systemd.services.bird.name ];
  };

  services.as10779 = {
    enable = true;

    local = {
      hostname = config.networking.hostName;
      interface = {
        local = "dummy0";
        primary = "enp3s0";
      };
      ipv4.addresses = [
        "23.161.104.131/32" # unicast
        "23.161.104.17/32" # personal site anycast
        "44.32.189.0/24" # 44net anycast test
      ];
      ipv6.addresses = [
        "2620:be:a000::23:161:104:131/128" # unicast
        "2620:be:a000::23:161:104:17/128" # personal site anycast
      ];
    };

    router = {
      id = lib.blueprint.hosts.diablo.ipv4;
      exit = false;
      secret = config.sops.secrets.bgp.path;
      source = { inherit (lib.blueprint.hosts.diablo) ipv4 ipv6; };
      static = {
        ipv4.routes = [{ prefix = "23.161.104.0/24"; option = "reject"; }];
        ipv6.routes = [{ prefix = "2620:be:a000::/48"; option = "reject"; }];
      };
      sessions = [
        # {
        #   name = "misaka";
        #   password = "PASS_AS917";
        #   type = { ipv4 = "direct"; ipv6 = "direct"; };
        #   neighbor = {
        #     asn = 64515;
        #     ipv4 = "";
        #     ipv6 = "";
        #   };
        #   import = {
        #     ipv4 = "import filter ${cfg.router.rpki.ipv4.filter};";
        #     ipv6 = "import filter ${cfg.router.rpki.ipv6.filter};";
        #   };
        #   export = {
        #     ipv4 = ''export where proto = "${cfg.router.static.ipv4.name}";'';
        #     ipv6 = ''export where proto = "${cfg.router.static.ipv6.name}";'';
        #   };
        # }
        # {
        #   name = "bgptools";
        #   password = null;
        #   type = { ipv4 = "multihop"; ipv6 = "multihop"; };
        #   neighbor = {
        #     asn = 212232;
        #     ipv4 = "";
        #     ipv6 = "";
        #   };
        #   addpath = "tx";
        #   import = {
        #     ipv4 = "import none;";
        #     ipv6 = "import none;";
        #   };
        #   export = {
        #     ipv4 = "export all;";
        #     ipv6 = "export all;";
        #   };
        # }
      ];
    };
  };
}
