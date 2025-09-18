{ lib, ... }:

{ config, pkgs, ... }:

let
  cfg = config.services.home-assistant;
in
{
  config = lib.mkIf config.services.home-assistant.enable {
    services.caddy.enable = true;

    services.home-assistant = {
      openFirewall = false;

      config.default_config = { };
      config.homeassistant.time_zone = null;

      config.http = {
        server_host = "127.0.0.1";
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };

      extraComponents = [
        "apple_tv"
        "bluetooth"
        "cloud"
        "default_config"
        "homekit"
        "homekit_controller"
        "met"
        "ssdp"
        "switchbot"
        "switchbot_cloud"
        "zeroconf"
      ];

      customComponents = with pkgs.home-assistant-custom-components; [ midea_ac_lan ];
    };

    networking.firewall = {
      allowedTCPPorts = [ 21064 ];
      allowedUDPPorts = [ 5353 ];
    };

    services.caddy.virtualHosts."ha.ysun.co".extraConfig = ''
      import common
      tailscale_auth
      reverse_proxy ${cfg.config.http.server_host}:${lib.toString cfg.config.http.server_port} 
    '';
  };
}
