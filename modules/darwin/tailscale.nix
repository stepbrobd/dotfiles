{ lib, ... }:

{ config, ... }:

let
  inherit (lib) attrValues elem mkForce mkIf mkMerge;
in
{
  config = mkMerge [
    { services.tailscale.overrideLocalDns = true; }

    (mkIf (elem 1475387142 (attrValues config.homebrew.masApps)) {
      # Tailscale: `mas search 1475387142`
      services.tailscale.enable = mkForce false; # use tailscale from App Store
      environment.shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    })
  ];
}
