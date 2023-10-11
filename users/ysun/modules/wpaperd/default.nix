# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.wpaperd = {
    enable = true;
    settings.default = {
      duration = "24h";
      apply-shadow = true;
      sorting = "random";
      path = "${config.xdg.userDirs.pictures}/Wallpapers";
    };
  };
}
