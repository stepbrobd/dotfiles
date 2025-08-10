{ lib, ... }:

{ config, pkgs, ... }:

let
  metricsTarget = "127.0.0.1:9019";
  metricsPath = "/metrics";
in
{
  config = lib.mkIf config.services.caddy.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 443 ];

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
          allowed_http_verbs GET HEAD
          default_cache_control no-store
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

        (csp) {
          header  Content-Security-Policy      "default-src 'self' https://ysun.co https://*.ysun.co; base-uri 'self' https://ysun.co https://*.ysun.co; form-action 'self' https://ysun.co https://*.ysun.co; frame-ancestors 'self' https://ysun.co https://*.ysun.co; img-src 'self' https://ysun.co https://*.ysun.co data:; worker-src 'self' https://ysun.co https://*.ysun.co; font-src 'self' https://ysun.co https://*.ysun.co data:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ysun.co https://*.ysun.co https://static.cloudflareinsights.com; connect-src 'self' https://ysun.co https://*.ysun.co https://cloudflareinsights.com; style-src 'self' 'unsafe-inline' https://ysun.co https://*.ysun.co; frame-src 'self' https://ysun.co https://*.ysun.co; media-src 'self' https://ysun.co https://*.ysun.co;"
          header >Content-Security-Policy (.*) "default-src 'self' https://ysun.co https://*.ysun.co; base-uri 'self' https://ysun.co https://*.ysun.co; form-action 'self' https://ysun.co https://*.ysun.co; frame-ancestors 'self' https://ysun.co https://*.ysun.co; img-src 'self' https://ysun.co https://*.ysun.co data:; worker-src 'self' https://ysun.co https://*.ysun.co; font-src 'self' https://ysun.co https://*.ysun.co data:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ysun.co https://*.ysun.co https://static.cloudflareinsights.com; connect-src 'self' https://ysun.co https://*.ysun.co https://cloudflareinsights.com; style-src 'self' 'unsafe-inline' https://ysun.co https://*.ysun.co; frame-src 'self' https://ysun.co https://*.ysun.co; media-src 'self' https://ysun.co https://*.ysun.co;"
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
