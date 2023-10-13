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
      command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        theme_name = "Nordic";
        icon_theme_name = "Nordzy-dark";
        font_name = "Noto Sans Regular 12";
        application_prefer_dark_theme = true;
      };
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
