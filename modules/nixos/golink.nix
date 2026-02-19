{ inputs, lib, ... }:

{ config, ... }:

let
  inherit (lib) mkIf;

  cfg = config.services.golink;
in
{
  imports = [ inputs.golink.nixosModules.default ];

  config = mkIf cfg.enable {
    sops.secrets.golink = {
      owner = config.services.golink.user;
      group = config.services.golink.group;
    };

    services.golink.tailscaleAuthKeyFile = config.sops.secrets.golink.path;
    # systemd.services.golink.environment.TSNET_FORCE_LOGIN = "1";
  };
}
