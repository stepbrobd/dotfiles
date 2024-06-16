# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{

  config = lib.mkMerge [
    { services.tailscale.overrideLocalDns = true; }

    (lib.mkIf (lib.elem "Tailscale" (lib.attrNames config.homebrew.masApps)) {
      services.tailscale.enable = lib.mkForce false;
    })
  ];
}
