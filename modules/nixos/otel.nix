{ lib, ... }:

{ config, ... }:

let
  inherit (lib) genAttrs mkIf mkOption toString types;

  cfg = config.services.grafana;
in
{
  options.services.grafana = {
    mainDomain = mkOption {
      default = "otel.ysun.co";
      description = "Main domain to serve grafana on";
      example = "otel.ysun.co";
      type = types.str;
    };

    extraDomains = mkOption {
      default = [ ];
      description = "List of extra domains aside from main domain to serve grafana on";
      example = [ "otel.ysun.co" ];
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = genAttrs ([ cfg.mainDomain ] ++ cfg.extraDomains) (domain: {
        extraConfig = with config.services.grafana.settings.server; ''
          import common
          reverse_proxy ${toString http_addr}:${toString http_port} {
            header_up Host {host}
            header_up X-Real-IP {http.request.header.CF-Connecting-IP}
          }
        '';
      });
    };

    services.grafana = {
      settings = {
        analytics.reporting_enabled = false;
        server = {
          http_addr = "127.0.0.1";
          http_port = 25000;
          domain = cfg.mainDomain;
          root_url = "https://${cfg.mainDomain}/";
        };
      };
    };
  };
}
