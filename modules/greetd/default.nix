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
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${config.programs.hyprland.package}/bin/Hyprland --time --remember --asterisks --power-shutdown shutdown now --power-reboot reboot";
    };
  };
}
