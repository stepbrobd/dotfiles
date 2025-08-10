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
        "2620:be:a000::23:161:104:17/128"
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
            serverAliases = [
              # my weird flex -
              # dont redirect arpa zones
              # but cannot get certificates
              "http://0.0.0.a.e.b.0.0.0.2.6.2.ip6.arpa"
              "http://104.161.23.in-addr.arpa"
              "http://136.104.192.in-addr.arpa"
            ];
          };

          virtualHosts."*.ysun.co" = {
            logFormat = lib.mkForce config.services.caddy.virtualHosts."ysun.co".logFormat;
            extraConfig = ''
              ${common}
              redir https://ysun.co{uri} permanent
            '';
            serverAliases = [
              "*.as10779.net"
              "*.churn.cards"
              "*.deeznuts.phd"
              "*.internal.center"
              "*.stepbrobd.com"
              "*.xdg.sh"
              "*.ysun.life"
              "as10779.net"
              "churn.cards"
              "deeznuts.phd"
              "internal.center"
              "stepbrobd.com"
              "xdg.sh"
              "ysun.life"
            ];
          };
        };
    };
}
