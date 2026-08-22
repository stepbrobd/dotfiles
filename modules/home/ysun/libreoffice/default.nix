{ lib, ... }:

{ pkgs, ... }:

{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.libreoffice-qt-stable
    pkgs.hyphenDicts.en-us
    pkgs.hyphenDicts.fr-fr
  ];
}
