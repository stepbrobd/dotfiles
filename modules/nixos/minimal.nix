# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./tailscale.nix
  ];
}
