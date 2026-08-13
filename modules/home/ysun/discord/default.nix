{ pkgs, ... }:

{
  programs.vesktop = {
    enable = pkgs.stdenv.hostPlatform.isLinux;

    settings.splashBackground = "#2c2d32";
  };

  xdg.mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
  xdg.mimeApps.associations.added."x-scheme-handler/discord" = [ "vesktop.desktop" ];
  xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = [ "vesktop.desktop" ];
}
