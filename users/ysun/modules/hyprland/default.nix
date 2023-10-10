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
            # Setup
      	    env = HYPRLAND_LOG_WLR,1

      	    env = XDG_SESSION_TYPE,"wayland"
      	    env = XDG_SESSION_DESKTOP,"Hyprland"
      	    env = XDG_CURRENT_DESKTOP,"Hyprland"

      	    env = GDK_BACKEND,"wayland"
      	    env = QT_QPA_PLATFORM,"wayland;xcb"
      	    env = QT_QPA_PLATFORMTHEME,"qt5ct"
      	    env = WLR_DRM_NO_MODIFIERS,1

            env = GDK_SCALE,2
            env = XCURSOR_SIZE,32
            monitor = , preferred, auto, 1
            xwayland {
              force_zero_scaling = true
            }
      
            exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 
            exec-once = waybar

            # Input
            input {
                kb_layout = us
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =

                sensitivity = 0.5
                follow_mouse = 1
                natural_scroll = true
                scroll_method = 2fg
      
                touchpad {
                    natural_scroll = true
                }
            }

            $mod = SUPER

            bind = $mod, M, exit,

            # Application: $mod + [a-z]
            bind = $mod, B, exec, ${config.home.sessionVariables.BROWSER}
            bind = $mod, T, exec, ${config.home.sessionVariables.TERMINAL}

            # Switch Workspace: $mod + [0-9]
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

            # Move to Workspace: $mod SHIFT + [0-9]
            bind = $mod SHIFT, 1, movetoworkspace, 1
            bind = $mod SHIFT, 2, movetoworkspace, 2
            bind = $mod SHIFT, 3, movetoworkspace, 3
            bind = $mod SHIFT, 4, movetoworkspace, 4
            bind = $mod SHIFT, 5, movetoworkspace, 5
            bind = $mod SHIFT, 6, movetoworkspace, 6
            bind = $mod SHIFT, 7, movetoworkspace, 7
            bind = $mod SHIFT, 8, movetoworkspace, 8
            bind = $mod SHIFT, 9, movetoworkspace, 9
            bind = $mod SHIFT, 0, movetoworkspace, 0
    '';
  };
}
