# nixpkgs options

{ config
, lib
, pkgs
, options
, ...
}:

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
        plymouth.enable = true;
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
    }

    # screen sharing
    { environment.systemPackages = [ pkgs.xwaylandvideobridge ]; }

    # xdg
    {
      xdg.portal = {
        enable = true;
        lxqt.enable = true;
        wlr.enable = true;
        xdgOpenUsePortal = true;
        config.common.default = "*";
      };
    }

    # login manager
    {
      services.xserver.enable = true;
      services.displayManager = {
        defaultSession = "${cfg.enabled}";
        sddm.wayland.enable = true; # lightdm
      };
    }

    (mkIf (cfg.enabled == "hyprland") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    })

    (mkIf (cfg.enabled == "plasma") {
      services = {
        desktopManager.plasma6.enable = true;
        # can't use with plasma
        power-profiles-daemon.enable = false;
      };
      # IME
      i18n.inputMethod.fcitx5.plasma6Support = true;
    })
  ]);
}
