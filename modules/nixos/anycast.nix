{ inputs, lib, ... }:

{ config, options, pkgs, ... }:

let
  ysun = inputs.ysun.packages.${pkgs.stdenv.system}.default;
  bind = "127.0.0.1";
  port = 13000;
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
        # virtualHosts."anycast.as10779.net".extraConfig = ''
        #   import common
        #   respond ${config.networking.hostName} 
        # '';
        virtualHosts."anycast.as10779.net".extraConfig = ''
          import common
          reverse_proxy ${bind}:${lib.toString port}
        '';
      };

      systemd.services.ysun = {
        description = "personal homepage anycast test";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        script = "${ysun}/bin/ysun ${bind} ${toString port}";
      };
    };
}
