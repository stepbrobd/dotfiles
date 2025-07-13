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
      services.caddy = {
        enable = true;
        virtualHosts."anycast.as10779.net".extraConfig = ''
          import common
          header X-Served-By "${config.networking.fqdn}"

          root * ${ysun}/var/www/html
          file_server

          handle_errors {
            rewrite * /error
            file_server
          }
        '';
      };
    };
}
