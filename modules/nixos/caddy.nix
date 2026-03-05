{ lib, ... }:

{ config, ... }:

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

      email = "ysun@hey.com";

      globalConfig = ''
        admin unix/${config.services.caddy.dataDir}/admin.sock

        # dns cloudflare {env.CF_API_TOKEN}
        # ech ech.ysun.co

        order authenticate before respond
        order authorize before basicauth

        cache {
          log_level ERROR
          badger
          allowed_http_verbs GET HEAD
          default_cache_control no-store
        }

        cert_issuer acme {
          profile shortlived
        }

        servers {
          trusted_proxies cloudflare {
            interval 24h
            timeout 60s
          }
        }

        storage s3 {
          host       {env.S3_HOST}
          bucket     {env.S3_BUCKET}
          access_id  {env.S3_ACCESS_ID}
          secret_key {env.S3_SECRET_KEY}
          prefix     {env.S3_PREFIX}
          insecure   false
        }

        security {
          oauth identity provider kanidm {
            realm kanidm
            driver generic
            client_id {env.CADDY_KANIDM_CLIENT_ID}
            client_secret {env.CADDY_KANIDM_CLIENT_SECRET}
            scopes openid email profile
            metadata_url https://sso.ysun.co/oauth2/openid/caddy/.well-known/openid-configuration
          }

          authentication portal oidc {
            crypto default token lifetime 86400
            crypto key sign-verify {env.CADDY_KANIDM_JWT_SECRET}
            enable identity provider kanidm
            cookie domain ysun.co

            transform user {
              match realm kanidm
              action add role authenticated
            }
          }

          authorization policy oidc {
            set auth url https://proxy.ysun.co/oauth2/kanidm
            crypto key verify {env.CADDY_KANIDM_JWT_SECRET}
            allow roles authenticated
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

        (auth) {
          authenticate with oidc
          authorize with oidc
        }

        (csp) {
          header  Content-Security-Policy      "default-src 'self' https://ysun.co https://*.ysun.co; base-uri 'self' https://ysun.co https://*.ysun.co; form-action 'self' https://ysun.co https://*.ysun.co; frame-ancestors 'self' https://ysun.co https://*.ysun.co https://gskr.ing; img-src 'self' https://ysun.co https://*.ysun.co https://*.mzstatic.com data:; worker-src 'self' https://ysun.co https://*.ysun.co; font-src 'self' https://ysun.co https://*.ysun.co https://www.apple.com data:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ysun.co https://*.ysun.co https://static.cloudflareinsights.com https://js-cdn.music.apple.com https://embed.music.apple.com; connect-src 'self' https://ysun.co https://*.ysun.co https://cloudflareinsights.com https://api.github.com https://amp-api.music.apple.com https://xp.apple.com; style-src 'self' 'unsafe-inline' https://ysun.co https://*.ysun.co https://www.apple.com; frame-src 'self' https://ysun.co https://*.ysun.co https://embed.music.apple.com; media-src 'self' https://ysun.co https://*.ysun.co; report-uri https://ysun.co/csp;"
          header >Content-Security-Policy (.*) "default-src 'self' https://ysun.co https://*.ysun.co; base-uri 'self' https://ysun.co https://*.ysun.co; form-action 'self' https://ysun.co https://*.ysun.co; frame-ancestors 'self' https://ysun.co https://*.ysun.co https://gskr.ing; img-src 'self' https://ysun.co https://*.ysun.co https://*.mzstatic.com data:; worker-src 'self' https://ysun.co https://*.ysun.co; font-src 'self' https://ysun.co https://*.ysun.co https://www.apple.com data:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ysun.co https://*.ysun.co https://static.cloudflareinsights.com https://js-cdn.music.apple.com https://embed.music.apple.com; connect-src 'self' https://ysun.co https://*.ysun.co https://cloudflareinsights.com https://api.github.com https://amp-api.music.apple.com https://xp.apple.com; style-src 'self' 'unsafe-inline' https://ysun.co https://*.ysun.co https://www.apple.com; frame-src 'self' https://ysun.co https://*.ysun.co https://embed.music.apple.com; media-src 'self' https://ysun.co https://*.ysun.co; report-uri https://ysun.co/csp;"
        }
      '';

      virtualHosts."proxy.ysun.co".extraConfig = ''
        import common
        authenticate with oidc
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
      # remove after https://github.com/nixos/nixpkgs/pull/471670 is merged
      # CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      # MemoryDenyWriteExecute = true;
      # LockPersonality = true;
      # ProcSubset = "pid";
      # ProtectClock = true;
      # ProtectControlGroups = true;
      # ProtectHostname = true;
      # ProtectKernelLogs = true;
      # ProtectKernelModules = true;
      # ProtectKernelTunables = true;
      # ProtectProc = "invisible";
      # ProtectSystem = "strict";
      # RestrictAddressFamilies = [
      #   "AF_UNIX"
      #   "AF_INET"
      #   "AF_INET6"
      # ];
      # RestrictNamespaces = true;
      # RestrictRealtime = true;
      # RestrictSUIDSGID = true;
      # RemoveIPC = true;
      # SystemCallArchitectures = "native";
      # SystemCallFilter = [
      #   "@system-service"
      #   "~@privileged"
      # ];
    };
  };
}
