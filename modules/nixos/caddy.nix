{ lib, ... }:

{ config, pkgs, ... }:

let
  metricsTarget = "127.0.0.1:9019";
  metricsPath = "/metrics";
in
{
  config = lib.mkIf config.services.caddy.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 80 443 ];

    services.prometheus.scrapeConfigs = [{
      job_name = "prometheus-caddy-exporter";
      static_configs = [{ targets = [ metricsTarget ]; }];
      metrics_path = metricsPath;
    }];

    services.caddy = {
      enableReload = config.services.caddy.enable;
      package = pkgs.caddy-with-plugins;
      email = "ysun@hey.com";

      globalConfig = ''
        admin unix/${config.services.caddy.dataDir}/admin.sock

        cache {
          log_level ERROR
          badger
        }

        servers {
          trusted_proxies cloudflare {
            interval 24h
            timeout 60s
          }
        }
      '';

      extraConfig = ''
        (common) {
          tls { dns cloudflare {env.CF_API_TOKEN} }
          encode br zstd gzip
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            X-Content-Type-Options "nosniff"
            X-XSS-Protection "1; mode=block"
            -Last-Modified
            -Server
            -X-Powered-By
          }
        }
      '';

      virtualHosts."http://${metricsTarget}" = {
        logFormat = lib.mkForce "output discard";
        extraConfig = ''
          metrics ${metricsPath}
        '';
      };
    };

    sops.secrets.caddy = {
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };

    systemd.services.caddy.serviceConfig = {
      EnvironmentFile = [ config.sops.secrets.caddy.path ];
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
