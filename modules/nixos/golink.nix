{ inputs, lib, ... }:

{ config, ... }:

let
  inherit (lib) mkIf;

  cfg = config.services.golink;
in
{
  imports = [ inputs.golink.nixosModules.default ];

  config = mkIf cfg.enable {
    age.secrets.tailscale = {
      file = "${inputs.self.outPath}/secrets/tailscale.age";
      owner = config.services.golink.user;
      group = config.services.golink.group;
    };

    services.golink.tailscaleAuthKeyFile = config.age.secrets.tailscale.path;
  };
}
