{ inputs, lib, ... }:

{ config, options, pkgs, ... }:

let
  ysun = inputs.ysun.packages.${pkgs.stdenv.system}.default;
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
            import zerossl
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

              handle_errors {
                rewrite * /error
                file_server
              }
            '';
          };

          # dont redirect arpa zones
          virtualHosts."0.0.9.5.f.2.0.6.2.ip6.arpa" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = arpa;
          };
          virtualHosts."104.161.23.in-addr.arpa" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = arpa;
          };
          virtualHosts."136.104.192.in-addr.arpa" = {
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
              "ysun.life"
              "*.as10779.net"
              "*.as18932.net"
              "*.churn.cards"
              "*.deeznuts.phd"
              "*.internal.center"
              "*.rkt.lol"
              "*.stepbrobd.com"
              "*.xdg.sh"
              "*.ysun.life"
            ];
          };
        };
    };
}
