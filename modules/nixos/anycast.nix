{ inputs, lib, ... }:

{ config, options, pkgs, ... }:

let
  ysun = inputs.ysun.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # anycast test
  # later will be changed to serve
  # my personal site
  config = lib.mkIf
    (
      options.services?as10779
      &&
      lib.elem
        "23.161.104.17/32"
        config.services.as10779.local.ipv4.addresses
      &&
      lib.elem
        "2602:f590:0::23:161:104:17/128"
        config.services.as10779.local.ipv6.addresses
    )
    {
      # https://nixpkgs-tracker.ocfox.me/?pr=455610
      services.go-csp-collector = {
        enable = true;
        settings = {
          output-format = "json";
          health-check-path = "/health";
          log-client-ip = true;
          query-params-metadata = true;
          truncate-query-fragment = false;
          debug = false;
        };
      };

      services.caddy =
        let
          common = ''
            import common
            import csp
            cache {
              ttl 60s
              default_cache_control "public, max-age=60, must-revalidate"
            }
            header X-Served-By "${config.networking.fqdn}"
          '';

          arpa = ''
            ${config.services.caddy.virtualHosts."ysun.co".extraConfig}
          '';
        in
        {
          enable = true;
          virtualHosts."ysun.co" = {
            extraConfig = ''
              ${common}

              root * ${ysun}/var/www/html
              file_server

              @csp path /csp/health || (method POST && path /csp/*) 
              handle @csp {
                uri strip_prefix /csp/
                reverse_proxy [::1]:${lib.toString config.services.go-csp-collector.settings.port}
              }

              handle_errors {
                rewrite * /error
                file_server
              }
            '';
          };

          # dont redirect arpa zones
          # keep is this way in case i want to try out new CA
          # already tried lets encrypt, zerossl, ssl.com
          virtualHosts."http://0.0.9.5.f.2.0.6.2.ip6.arpa" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = arpa;
          };
          virtualHosts."http://104.161.23.in-addr.arpa" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = arpa;
          };
          virtualHosts."http://136.104.192.in-addr.arpa" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = arpa;
          };

          virtualHosts."*.ysun.co" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = ''
              ${common}
              redir https://ysun.co{uri} permanent
            '';
            serverAliases = [
              "as10779.net"
              "as18932.net"
              "churn.cards"
              "deeznuts.phd"
              "internal.center"
              "rkt.lol"
              "stepbrobd.com"
              "xdg.sh"
              "*.as10779.net"
              "*.as18932.net"
              "*.churn.cards"
              "*.deeznuts.phd"
              "*.internal.center"
              "*.rkt.lol"
              "*.stepbrobd.com"
              "*.xdg.sh"
            ];
          };
        };
    };
}
