# hyprland options (from [hyprland](https://github.com/hyprwm/hyprland))

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [ inputs.hyprland.nixosModules.default ];

  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    lxqt.enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
  };
}
