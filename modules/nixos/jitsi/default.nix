{ lib, ... }:

{ config, ... }:

let
  cfg = config.services.jitsi;
  hasTag = lib.hasTag config.networking.hostName;
  inherit (lib.blueprint.services.jitsi) domain;
in
{
  options.services.jitsi = {
    enable = lib.mkEnableOption "Jitsi Meet";
  };

  config = lib.mkMerge [
    (lib.mkIf (hasTag "jitsi") {
      services.jitsi.enable = lib.mkDefault true;
    })
    (lib.mkIf cfg.enable {
      services.caddy.virtualHosts.${domain} = {
        extraConfig = lib.mkBefore ''
          import common
        '';
      };

      services.jitsi-videobridge.openFirewall = true;

      services.jitsi-meet = {
        enable = true;
        hostName = domain;

        caddy.enable = true;
        nginx.enable = false;

        prosody.lockdown = true;

        config = {
          defaultLang = "en";
          analytics.disabled = true;
          enableWelcomePage = false;
          prejoinConfig.enabled = true;
          requireDisplayName = true;
          maxFullResolutionParticipants = 1;
          p2p.stunServers = [
            { urls = "stun:stun.cloudflare.com:3478"; }
            { urls = "stun:meet-jit-si-turnrelay.jitsi.net:443"; }
            { urls = "stun:stun.l.google.com:19302"; }
          ];
          constraints.video.height = {
            ideal = 720;
            max = 1080;
            min = 240;
          };
        };

        interfaceConfig = {
          DISABLE_PRESENCE_STATUS = true;
          GENERATE_ROOMNAMES_ON_WELCOME_PAGE = false;
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
        };
      };
    })
  ];
}
