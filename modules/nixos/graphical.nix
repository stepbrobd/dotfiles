# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./1password.nix
    ./desktop.nix
    ./fonts.nix
    ./i18n.nix
    ./tailscale.nix
  ];
}
