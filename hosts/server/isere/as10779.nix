{ config, ... }:

{
  services.as10779 = {
    enable = true;
    router.exit = false;

    local = {
      hostname = config.networking.hostName;
      interface = {
        local = "dummy0";
        primary = "end0";
      };
      ipv4.addresses = [
        "23.161.104.131/32"
      ];
      ipv6.addresses = [
        "2602:f590:0::23:161:104:131/128"
      ];
    };

    router.static = {
      ipv4.routes = [
        { prefix = "23.161.104.0/24"; option = "reject"; }
      ];
      ipv6.routes = [
        { prefix = "2602:f590::/36"; option = "reject"; }
      ];
    };
  };
}
