# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./fonts.nix
    # ./hyprland.nix
    ./i18n.nix
    ./plasma.nix
    ./plymouth.nix
    ./tailscale.nix
  ];
}
