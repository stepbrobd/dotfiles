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
