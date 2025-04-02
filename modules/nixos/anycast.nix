{ lib, ... }:

{ config, options, ... }:

{
  # anycast test
  # later will be changed to serve
  # my personal site
  services.caddy = lib.mkIf
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
      enable = true;
      virtualHosts."anycast.as10779.net".extraConfig = ''
        import common
        respond ${config.networking.hostName} 
      '';
    };
}
