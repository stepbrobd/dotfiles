{ inputs, lib, ... }:

{ config
, pkgs
, osConfig ? { services.desktopManager.enabled = null; }
, ...
}:

{
  imports = [
    ./dunst.nix
    ./rofi.nix
    ./theme.nix
    ./waybar.nix
    ./wpaperd.nix
  ];

  wayland.windowManager.hyprland =
    let
      style = pkgs.writeText "gtk.css" ''
        @import url("${pkgs.nordic}/share/themes/Nordic/gtk-3.0/gtk.css");
        window {
          background-image: url("${./wallpaper.jpg}");
          background-size: cover;
          background-position: center;
        }
      '';
    in
    {
      enable = osConfig.services.desktopManager.enabled == "hyprland";
      xwayland.enable = true;

      extraConfig = ''
        monitor = eDP-1, highres, 0x0, 1.5
        monitor = , preferred, auto, auto

        env = GDK_SCALE,1
        env = ELM_SCALE,1
        env = QT_SCALE_FACTOR,1
        env = XCURSOR_SIZE,24
        xwayland {
          force_zero_scaling = true
        }

        exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
        exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        exec-once = ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh &

        exec-once = ${pkgs.xwaylandvideobridge}/bin/xwaylandvideobridge &
        windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
        windowrulev2 = noanim,class:^(xwaylandvideobridge)$
        windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
        windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$

        exec-once = dunst &
        exec-once = waybar &
        exec-once = wpaperd &

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
          shadow {
            enabled = true
            ignore_window = true
            offset = 2 2
            range = 4
            render_power = 2
            color = 0x66000000
          }
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
          pseudotile = true
          preserve_split = true
        }

        # change to another locker
        bind = CTRL SUPER, Q, exec, ${pkgs.gtklock}/bin/gtklock --daemonize --style "${style}"
        bind = , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Volume: Mute/Unmute"
        bind = , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@)"
        bind = , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@)"
        bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Media: Previous"
        bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Media: Play/Pause"
        bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Media: Next"
        bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Brightness: $(${pkgs.brightnessctl}/bin/brightnessctl get)"
        bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%- && ${pkgs.dunst}/bin/dunstify --timeout=1000 --replace=1 "Brightness: $(${pkgs.brightnessctl}/bin/brightnessctl get)"
        bind = SUPER SHIFT, 3, exec, ${pkgs.grimblast}/bin/grimblast save screen
        bind = SUPER SHIFT, 4, exec, ${pkgs.grimblast}/bin/grimblast save active
        bind = SUPER SHIFT, 5, exec, ${pkgs.grimblast}/bin/grimblast save area

        $mod = SUPER

        bind = $mod, SPACE, exec, ${pkgs.rofi-wayland}/bin/rofi -show-icons -combi-modi window,drun,run,ssh -show combi

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

        bind = $mod, left, movecurrentworkspacetomonitor, l
        bind = $mod, right, movecurrentworkspacetomonitor, r

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
        bind = $mod CTRL, 0, movetoworkspace, 10
      '';
    };
}
