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
      user = "greeter";
      command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      GTK.application_prefer_dark_theme = true;
      background = {
        path = ./wallpaper.jpg;
        fit = "Cover";
      };
      commands = {
        reboot = "systemctl reboot";
        shutdown = "systemctl poweroff";
      };
    };
  };
}
