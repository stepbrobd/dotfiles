{ config, lib, ... }:

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
      ipv4.addresses = [ "23.161.104.133/32" ];
      ipv6.addresses = [ "2602:f590::23:161:104:133/128" ];
    };

    router.static = {
      ipv4.routes = [{ option = "reject"; prefix = "23.161.104.0/24"; }];
      ipv6.routes = [{ option = "reject"; prefix = "2602:f590::/36"; }];
    };
  };
}
