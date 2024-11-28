{ lib, ... }:

{ config, ... }:

let
  inherit (lib) genAttrs mkIf mkOption types;
in
{
  options.services.uptime-kuma.domains = mkOption {
    default = [ ];
    description = "List of domains to serve uptime-kuma on";
    example = [ "uptime.ysun.co" ];
    type = types.listOf types.str;
  };

  config = mkIf config.services.uptime-kuma.enable {
    services.uptime-kuma = {
      appriseSupport = true;
      settings = {
        HOST = "127.0.0.1";
        PORT = "13001";
      };
    };

    services.caddy = with config.services.uptime-kuma; {
      enable = true;

      virtualHosts = genAttrs domains (domain: {
        extraConfig = ''
          import common
          reverse_proxy ${settings.HOST}:${settings.PORT}
        '';
      });
    };
  };
}
