# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  services.tailscale.enable = true;
}
