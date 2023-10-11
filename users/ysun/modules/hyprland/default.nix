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
            monitor = , preferred, auto, auto

      	    env = HYPRLAND_LOG_WLR,1
      	    env = XDG_SESSION_TYPE,"wayland"
      	    env = XDG_SESSION_DESKTOP,"Hyprland"
      	    env = XDG_CURRENT_DESKTOP,"Hyprland"
      	    env = QT_QPA_PLATFORM,"wayland;xcb"
      	    env = QT_QPA_PLATFORMTHEME,"qt5ct"
      	    env = WLR_DRM_NO_MODIFIERS,1
            env = GDK_SCALE,2
            env = XCURSOR_SIZE,40

            xwayland {
              force_zero_scaling = true
            }
      
            exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = dunst
            exec-once = waybar

            general {
              gaps_in = 6
              gaps_out = 12
              border_size = 2
              col.active_border=0xffcba6f7
              col.inactive_border=0xff313244
              no_border_on_floating = true
              layout = dwindle
            }

            input {
                kb_layout = us
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =
                sensitivity = 0
                follow_mouse = 1
                natural_scroll = true
                scroll_method = 2fg
                touchpad {
                    natural_scroll = true
                }
            }

            gestures {
              workspace_swipe = true
              workspace_swipe_fingers = 3
            }

            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              mouse_move_enables_dpms = true
              no_vfr = false
              enable_swallow = true
              swallow_regex = ^(${config.home.sessionVariables.TERMINAL})$
            }

            decoration {
              rounding = 8
              multisample_edges = true

              active_opacity = 1.0
              inactive_opacity = 1.0

              # Blur
              blur = true
              blur_size = 10
              blur_passes = 4
              blur_new_optimizations = true

              # Shadow
              drop_shadow = true
              shadow_ignore_window = true
              shadow_offset = 2 2
              shadow_range = 4
              shadow_render_power = 2
              col.shadow = 0x66000000
            }

            animations {
              enabled = true

              bezier = overshot, 0.05, 0.9, 0.1, 1.05
              bezier = smoothOut, 0.36, 0, 0.66, -0.56
              bezier = smoothIn, 0.25, 1, 0.5, 1

              animation = windows, 1, 5, overshot, slide
              animation = windowsOut, 1, 4, smoothOut, slide
              animation = windowsMove, 1, 4, default
              animation = border, 1, 10, default
              animation = fade, 1, 10, smoothIn
              animation = fadeDim, 1, 10, smoothIn
              animation = workspaces, 1, 6, overshot, slidevert
            }

            dwindle {
              no_gaps_when_only = true
              pseudotile = true
              preserve_split = true
            }

            $mod = SUPER

            bind = $mod, M, exit,

            bind = $mod, B, exec, ${config.home.sessionVariables.BROWSER}
            bind = $mod, T, exec, ${config.home.sessionVariables.TERMINAL}

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
