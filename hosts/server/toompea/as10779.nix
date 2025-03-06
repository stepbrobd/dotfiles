{ config, ... }:

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
      id = "185.194.53.29";
      secret = config.sops.secrets.bgp.path;
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
        }
      ];
    };
  };
}
