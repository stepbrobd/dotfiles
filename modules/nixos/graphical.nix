# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./1password.nix
    ./fonts.nix
    # ./hyprland.nix
    ./i18n.nix
    ./plasma.nix
    ./plymouth.nix
    ./tailscale.nix
  ];
}
