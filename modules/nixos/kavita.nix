{ lib, ... }:

{ config, pkgs, ... }:

let
  hasTag = lib.hasTag config.networking.hostName;
  inherit (lib.blueprint.services.kavita) domain;

  cfg = config.services.kavita;
in
{
  config = lib.mkMerge [
    (lib.mkIf (hasTag "kavita") {
      services.kavita.enable = lib.mkDefault true;
    })

    (lib.mkIf cfg.enable {
      sops.secrets."kavita/token" = { };
      sops.secrets."kavita/oidc" = { };

      services.kavita = {
        tokenKeyFile = config.sops.secrets."kavita/token".path;
        settings = {
          IpAddresses = "::1";
          BaseUrl = "/";
          AllowIFraming = false;
          OpenIdConnectSettings = {
            Authority = "https://${lib.blueprint.services.kanidm.domain}/oauth2/openid/kavita";
            ClientId = "kavita";
            Secret = "@OIDC_SECRET@";
          };
        };
      };

      systemd.services.kavita = {
        serviceConfig.LoadCredential = [ "oidc:${config.sops.secrets."kavita/oidc".path}" ];
        preStart = lib.mkAfter ''
          ${pkgs.replace-secret}/bin/replace-secret '@OIDC_SECRET@' "$CREDENTIALS_DIRECTORY/oidc" '${cfg.dataDir}/config/appsettings.json'
        '';
      };

      # manual addition folder for library
      # scanned into kavita from admin ui
      systemd.tmpfiles.rules = [
        "d '${cfg.dataDir}/books' 0750 ${cfg.user} ${cfg.user} - -"
      ];

      services.caddy = {
        enable = true;
        virtualHosts.${domain}.extraConfig = with cfg.settings; ''
          import common
          import reporting
          reverse_proxy [${IpAddresses}]:${lib.toString Port}
        '';
      };
    })
  ];
}
