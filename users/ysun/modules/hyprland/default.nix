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
      monitor = eDP-1, highres, 0x0, 1.25
      monitor = , preferred, auto, auto

      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = dunst
      exec-once = waybar
      exec-once = wpaperd

      general {
        gaps_in = 4
        gaps_out = 4
        border_size = 2
        col.active_border=0xff4c566a
        col.inactive_border=0xff2e3440
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
        enable_swallow = true
        swallow_regex = ^(${config.home.sessionVariables.TERM})$
      }

      decoration {
        rounding = 8
        active_opacity = 1.0
        inactive_opacity = 1.0
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
        no_gaps_when_only = false
        pseudotile = true
        preserve_split = true
      }

      bind = ,XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%
      bind = ,XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-

      $mod = SUPER

      bind = $mod, B, exec, ${config.home.sessionVariables.BROWSER}
      bind = $mod, T, exec, ${config.home.sessionVariables.TERM}

      bind = $mod, M, exit,
      bind = $mod, Q, killactive,
      bind = $mod, F, fullscreen,
      bind = $mod, A, pseudo,
      bind = $mod, X, togglesplit,
      bind = $mod, Z, togglefloating,

      bind = $mod, H, movefocus, l
      bind = $mod, L, movefocus, r
      bind = $mod, K, movefocus, u
      bind = $mod, J, movefocus, d

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

      bindm = $mod CTRL, mouse:272, movewindow
      bindm = $mod CTRL, mouse:273, resizewindow

      bind = $mod CTRL, H, movewindow, l
      bind = $mod CTRL, L, movewindow, r
      bind = $mod CTRL, K, movewindow, u
      bind = $mod CTRL, J, movewindow, d

      bind = $mod CTRL, left, resizeactive, -20 0
      bind = $mod CTRL, right, resizeactive, 20 0
      bind = $mod CTRL, up, resizeactive, 0 -20
      bind = $mod CTRL, down, resizeactive, 0 20

      bind = $mod CTRL, 1, movetoworkspace, 1
      bind = $mod CTRL, 2, movetoworkspace, 2
      bind = $mod CTRL, 3, movetoworkspace, 3
      bind = $mod CTRL, 4, movetoworkspace, 4
      bind = $mod CTRL, 5, movetoworkspace, 5
      bind = $mod CTRL, 6, movetoworkspace, 6
      bind = $mod CTRL, 7, movetoworkspace, 7
      bind = $mod CTRL, 8, movetoworkspace, 8
      bind = $mod CTRL, 9, movetoworkspace, 9
      bind = $mod CTRL, 0, movetoworkspace, 0
    '';
  };
}
