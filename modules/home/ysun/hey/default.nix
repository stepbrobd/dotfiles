{ lib, ... }:

{ pkgs, ... }:

{
  home.packages = [ pkgs.hey-mail ];

  xdg.mimeApps.defaultApplications = lib.optionalAttrs pkgs.stdenv.isLinux {
    "x-scheme-handler/mailto" = [ "hey-mail.desktop" ];
  };
}
