{ lib, ... }:

{ config, ... }:

let
  cfg = config.services.jitsi;
in
{
  options.services.jitsi = {
    enable = lib.mkEnableOption "Jitsi Meet";

    mainDomain = lib.mkOption {
      default = "meet.ysun.co";
      description = "Main domain to serve Jitsi Meet on";
      example = "meet.ysun.co";
      type = lib.types.str;
    };

    extraDomains = lib.mkOption {
      default = [ ];
      description = "List of extra domains aside from main domain to serve Jitsi Meet on";
      example = [ "meet.ysun.co" ];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf (config.services.jitsi.enable) {
    nixpkgs.config.permittedInsecurePackages = [
      "jitsi-meet-1.0.8043"
    ];

    services.caddy.virtualHosts.${cfg.mainDomain} = {
      serverAliases = cfg.extraDomains;
      extraConfig = lib.mkBefore ''
        import common
      '';
    };

    services.prosody.checkConfig = false;

    services.jitsi-meet = {
      enable = true;
      hostName = cfg.mainDomain;

      caddy.enable = true;
      nginx.enable = false;

      prosody.lockdown = true;

      config = {
        defaultLang = "en";
        enableWelcomePage = false;
        prejoinPageEnabled = true;
      };

      interfaceConfig = {
        DISABLE_PRESENCE_STATUS = true;
        GENERATE_ROOMNAMES_ON_WELCOME_PAGE = false;
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
      };
    };
  };
}
