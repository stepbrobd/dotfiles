# home-manager options (from [hyprland](https://github.com/hyprwm/Hyprland/blob/main/nix/hm-module.nix))

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [ inputs.hyprland.homeManagerModules.default ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    recommendedEnvironment = true;

    extraConfig = ''
      # XWayland HiDPI
      monitor=,highres,auto,2
      env = GDK_SCALE,2
      env = XCURSOR_SIZE,32
      xwayland {
        force_zero_scaling = true
      }

      $mod = SUPER

      bind = $mod, Q, exec, alacritty
      bind = $mod, M, exit,

      # switch workspace: $mod + [0-9]
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10
    '';
  };
}
