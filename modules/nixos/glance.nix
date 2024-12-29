{ lib, ... }:

{ config, ... }:

let
  inherit (lib) genAttrs mkIf mkOption toString types;

  cfg = config.services.glance;
in
{
  options.services.glance.domains = mkOption {
    default = [ ];
    description = "List of domains to serve glance on";
    example = [ "home.ysun.co" ];
    type = types.listOf types.str;
  };

  config = mkIf cfg.enable {
    services.caddy = with cfg; {
      enable = true;

      virtualHosts = genAttrs domains (domain: {
        extraConfig = ''
          import common
          reverse_proxy ${settings.server.host}:${toString settings.server.port}
        '';
      });
    };

    services.glance.settings = {
      server = {
        host = "127.0.0.1";
        port = 30069;
      };
      theme = {
        background-color = "220 16 22";
        contrast-multiplier = 1.2;
        primary-color = "213 37 63";
        positive-color = "92 33 65";
        negative-color = "354 47 56";
      };
      pages = [
        {
          name = "Home";
          hideDesktopNavigation = true;
          centerVertically = true;
          columns = [
            {
              size = "small";
              widgets = [
                { type = "calendar"; }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                  search-engine = "https://kagi.com/search?q={QUERY}";
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Boston, Massachusetts, United States";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
