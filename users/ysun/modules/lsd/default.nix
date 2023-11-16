# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.lsd = {
    enable = true;
    settings = {
      icons.when = "auto";
      sorting.dir-grouping = "first";
      ignore-globs = [
        ".git"
      ];
    };
  };
}
