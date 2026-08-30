{ lib, ... }:

{ config, ... }:

let
  inherit (lib) any attrValues elem mkForce mkIf mkMerge;
in
{
  config = mkMerge [
    { services.tailscale.overrideLocalDns = true; }

    (mkIf
      (
        elem 1475387142 (attrValues config.homebrew.masApps)
        ||
        any (cask: elem cask.name [ "tailscale" "tailscale-app" ]) config.homebrew.casks
      )
      {
        services.tailscale.enable = mkForce false; # use tailscale from homebrew
        environment.shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      })
  ];
}
