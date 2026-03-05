{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.neogrok;
in
{
  options.services.neogrok = {
    enable = mkOption {
      default = false;
      description = "Whether to enable neogrok";
      type = types.bool;
    };

    host = mkOption {
      default = "127.0.0.1";
      description = "Host to bind to";
      type = types.str;
    };

    port = mkOption {
      default = 6071;
      description = "Port to listen on";
      type = types.port;
    };

    zoektUrl = mkOption {
      default = "http://localhost:6070";
      description = "URL of the zoekt indexing server";
      type = types.str;
    };

    domain = mkOption {
      default = "grep.ysun.co";
      description = "Domain to serve neogrok on";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts.${cfg.domain}.extraConfig = ''
        import common
        import auth
        reverse_proxy ${cfg.host}:${lib.toString cfg.port}
      '';
    };

    systemd.services.neogrok = {
      description = "Neogrok - code search UI for zoekt";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOST = cfg.host;
        PORT = lib.toString cfg.port;
        ZOEKT_URL = cfg.zoektUrl;
      };

      serviceConfig = {
        ExecStart = "${pkgs.neogrok}/bin/neogrok";
        Restart = "on-failure";
        DynamicUser = true;
      };
    };
  };
}
