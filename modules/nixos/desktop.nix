{ inputs, lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge mkOption types;

  cfg = config.services.desktopManager;
in
{
  options.services.desktopManager = {
    enabled = mkOption {
      type = with types; nullOr (enum [ "hyprland" "plasma" ]);
      default = null;
      example = "hyprland";
      description = ''
        Choose:
        - null (or nothing) -> no desktop manager
        - hyprland
        - plasma -> plasma6
      '';
    };
  };

  config = mkIf (cfg.enabled != null) (mkMerge [
    # disable boot logs when using a desktop manager
    {
      boot = {
        consoleLogLevel = 0;
        initrd = {
          verbose = false;
          systemd.enable = true;
        };
        kernelParams = [
          "quiet"
          "loglevel=3"
          "udev.log_level=3"
          "boot.shell_on_fail"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "vt.global_cursor_default=0"
        ];
      };

      # boot.loader.grub.theme = pkgs.nixos-grub2-theme;
      boot.plymouth.enable = true;
    }

    # screen sharing
    { environment.systemPackages = [ pkgs.kdePackages.xwaylandvideobridge ]; }

    # xdg
    {
      xdg.portal = {
        # a bit higher than mkDefault (1000)
        enable = lib.mkOverride 999 true;
        lxqt.enable = lib.mkOverride 999 true;
        wlr.enable = lib.mkOverride 999 true;
        xdgOpenUsePortal = lib.mkOverride 999 true;
        config.common.default = lib.mkOverride 999 "*";
      };
    }

    # gpg
    { programs.gnupg.agent.enable = true; }

    (mkIf (cfg.enabled == "hyprland") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages = [ pkgs.hyprland-qtutils ];

      environment.variables = {
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = 1;
        MOZ_WEBRENDER = 1;
        NIXOS_OZONE_WL = 1;
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = 1;
      };

      # login manager: use gtkgreet, and use gtklock for locker
      services.greetd = {
        enable = true;
        settings = {
          default_session =
            let
              style = pkgs.writeText "gtk.css" ''
                @import url("${pkgs.nordic}/share/themes/Nordic/gtk-3.0/gtk.css");
                window {
                  background-image: url("${../home/ysun/hyprland/wallpaper.jpg}");
                  background-size: cover;
                  background-position: center;
                }
              '';
            in
            {
              user = "greeter";
              command = lib.concatStringsSep " " [
                "${pkgs.cage}/bin/cage"
                "-s"
                "--"
                "${pkgs.greetd.gtkgreet}/bin/gtkgreet"
                "-l"
                "-s"
                "${style}"
              ];
            };
          initial_session = {
            user = "ysun";
            command = "Hyprland";
          };
        };
      };

      # locker
      security.pam.services.gtklock = { };

      # gnome polkit and keyring are used for hyprland sessions
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
    })

    (mkIf (cfg.enabled == "plasma") {
      services = {
        desktopManager.plasma6.enable = true;
        # can't use with plasma
        power-profiles-daemon.enable = false;
      };

      # login manager
      services.xserver.enable = true;
      services.displayManager = {
        defaultSession = "plasma";
        sddm.enable = true;
        sddm.wayland.enable = true;
      };

      # kwallet
      security.pam.services.kdewallet.kwallet.enable = true;

      # IME
      i18n.inputMethod.fcitx5.plasma6Support = true;
    })
  ]);
}
