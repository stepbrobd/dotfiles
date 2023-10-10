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
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${config.programs.hyprland.package}/bin/Hyprland";
    };
  };
}
