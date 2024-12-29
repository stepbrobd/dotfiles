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
                  location = "Boston, Massachusetts, United States";
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
                        { title = "Plausible"; url = "https://stats.ysun.co/ysun.co"; icon = "si:plausibleanalytics"; same-tab = true; }
                        { title = "NextDNS"; url = "https://my.nextdns.io/"; icon = "si:nextdns"; same-tab = true; }
                        { title = "Tailscale"; url = "https://login.tailscale.com/admin/machines"; icon = "si:tailscale"; same-tab = true; }
                        { title = "Cloudflare"; url = "https://dash.cloudflare.com/6ff6fca6d9ffe9c77dd15a9095076b3b"; icon = "si:cloudflare"; same-tab = true; }
                        { title = "AWS"; url = "https://eu-central-2.console.aws.amazon.com/ec2/home?region=eu-central-2#Instances:"; icon = "si:amazonwebservices"; same-tab = true; }
                      ];
                    }
                    {
                      links = [
                        { title = "Lemmy"; url = "https://phtn.app/"; icon = "si:lemmy"; same-tab = true; }
                        { title = "NixOS"; url = "https://discourse.nixos.org/"; icon = "si:nixos"; same-tab = true; }
                        { title = "Framework"; url = "https://community.frame.work/"; icon = "si:framework"; same-tab = true; }
                        { title = "OCaml"; url = "https://discuss.ocaml.org/"; icon = "si:ocaml"; same-tab = true; }
                        { title = "Churning"; url = "https://www.uscardforum.com/"; icon = "si:cashapp"; same-tab = true; }
                        { title = "Timetable"; url = "https://animeschedule.net/"; icon = "si:myanimelist"; same-tab = true; }
                      ];
                    }
                  ];
                }
                {
                  type = "lobsters";
                  limit = 10;
                }
                {
                  type = "hacker-news";
                  limit = 10;
                }
                {
                  type = "html";
                  source = ''<script defer data-domain="home.ysun.co" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script>'';
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
