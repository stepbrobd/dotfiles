{ lib, ... }:

{ pkgs, ... }:

{
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [ pkgs.slack ];

  xdg.mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
  xdg.mimeApps.associations.added."x-scheme-handler/slack" = [ "slack.desktop" ];
  xdg.mimeApps.defaultApplications."x-scheme-handler/slack" = [ "slack.desktop" ];
}
