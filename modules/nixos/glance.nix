{ lib, ... }:

{ config, ... }:

let
  inherit (lib) mkIf mkOption toString types;

  cfg = config.services.glance;
in
{
  options.services.glance = {
    mainDomain = mkOption {
      default = "home.ysun.co";
      description = "Main domain to serve glance on";
      example = "home.ysun.co";
      type = types.str;
    };

    extraDomains = mkOption {
      default = [ ];
      description = "List of domains to serve glance on";
      example = [ "home.ysun.co" ];
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    services.caddy = with cfg; {
      enable = true;

      virtualHosts.${cfg.mainDomain} = {
        serverAliases = cfg.extraDomains;
        extraConfig = ''
          import common
          header Cache-Control "public, max-age=600, must-revalidate"
          reverse_proxy ${settings.server.host}:${toString settings.server.port}
        '';
      };
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
      document.head = ''<script defer data-domain="home.ysun.co" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script>'';
      branding = {
        hide-footer = true;
        favicon-url = "https://ysun.co/assets/static/img/favicon.ico";
        logo-url = "https://ysun.co/assets/static/img/favicon.ico";
      };
      pages = [
        {
          name = "Home";
          center-vertically = true;
          hide-desktop-navigation = true;
          width = "slim";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "weather";
                  units = "metric";
                  hour-format = "24h";
                  hide-location = false;
                  show-area-name = true;
                  location = "Grenoble, Auvergne-Rhône-Alpes, France";
                }
                {
                  type = "search";
                  autofocus = true;
                  search-engine = "https://kagi.com/search?q={QUERY}";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      links = [
                        { title = "GoLink"; url = "https://go.tail650e82.ts.net/"; icon = "si:shortcut"; same-tab = true; }
                        { title = "Telemetry"; url = "https://otel.ysun.co/dashboards"; icon = "si:grafana"; same-tab = true; }
                        { title = "Plausible"; url = "https://stats.ysun.co/ysun.co"; icon = "si:plausibleanalytics"; same-tab = true; }
                        { title = "NextDNS"; url = "https://my.nextdns.io/"; icon = "si:nextdns"; same-tab = true; }
                        { title = "Tailscale"; url = "https://login.tailscale.com/admin/machines"; icon = "si:tailscale"; same-tab = true; }
                        { title = "Cloudflare"; url = "https://dash.cloudflare.com/6ff6fca6d9ffe9c77dd15a9095076b3b"; icon = "si:cloudflare"; same-tab = true; }
                      ];
                    }
                    {
                      links = [
                        { title = "Hey"; url = "https://app.hey.com/imbox"; icon = "si:hey"; same-tab = true; }
                        { title = "NixOS"; url = "https://discourse.nixos.org/"; icon = "si:nixos"; same-tab = true; }
                        { title = "Calibre"; url = "https://read.ysun.co"; icon = "si:calibreweb"; same-tab = true; }
                        { title = "AniList"; url = "https://anilist.co/home"; icon = "si:anilist"; same-tab = true; }
                        { title = "Timetable"; url = "https://animeschedule.net/"; icon = "si:myanimelist"; same-tab = true; }
                        { title = "ニコニコ"; url = "https://site.nicovideo.jp/danime/"; icon = "si:niconico"; same-tab = true; }
                      ];
                    }
                  ];
                }
                {
                  type = "group";
                  widgets = [
                    { type = "lobsters"; limit = 10; }
                    { type = "hacker-news"; limit = 10; }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
