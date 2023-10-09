# home-manager options

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [ inputs.hyprland.homeManagerModules.default ];
}
