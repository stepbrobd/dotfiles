# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      vt = "next";
      user = "greeter";
      command = lib.strings.concatStringsSep " " [
        "${pkgs.greetd.tuigreet}/bin/tuigreet"
        "--issue"
        "--time"
        "--time-format %A - %B %-d, %Y - %-H:%M:%S"
        "--remember"
        "--user-menu"
        "--asterisks"
        "--power-no-setsid"
        "--power-shutdown shutdown now"
        "--power-reboot reboot"
        "--cmd Hyprland"
      ];
    };
  };
}
