{ config
, lib
, pkgs
, ...
}:

{
  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      icons.when = "auto";
      sorting.dir-grouping = "first";
      ignore-globs = [
        ".git"
      ];
    };
  };
}
