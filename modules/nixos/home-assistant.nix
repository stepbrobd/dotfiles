{ lib, ... }:

{ config, ... }:

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
        "homekit"
        "homekit_controller"
        "met"
        "switchbot"
        "switchbot_cloud"
      ];
    };

    networking.firewall = {
      allowedTCPPorts = [ 21064 ];
      allowedUDPPorts = [ 5353 ];
    };

    services.caddy.virtualHosts."ha.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${cfg.config.http.server_host}:${lib.toString cfg.config.http.server_port} 
    '';
  };
}
