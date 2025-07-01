{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf mkPackageOption mkOption;

  cfg = config.programs.openconnect;
in
{
  options.programs.openconnect = {
    enable = mkEnableOption "OpenConnect client" // { default = true; };

    package = mkPackageOption pkgs "openconnect" { };

    userFile = mkOption {
      type = types.path;
      description = "Path to the VPN user file";
    };

    passFile = mkOption {
      type = types.path;
      description = "Path to the VPN password file";
    };

    connFile = mkOption {
      type = types.path;
      description = "Path to the VPN connection URL";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."openconnect/user" = { };
    sops.secrets."openconnect/pass" = { };
    sops.secrets."openconnect/conn" = { };

    programs.openconnect = {
      userFile = config.sops.secrets."openconnect/user".path;
      passFile = config.sops.secrets."openconnect/pass".path;
      connFile = config.sops.secrets."openconnect/conn".path;
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "openconnect";
        runtimeInputs = [
          pkgs.coreutils
          cfg.package
        ];
        text = ''
          openconnect \
            --protocol=anyconnect \
            --passwd-on-stdin \
            --user="$(cat ${cfg.userFile})" \
            "$(cat ${cfg.connFile})" < ${cfg.passFile}
        '';
      })
    ];
  };
}
