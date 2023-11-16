# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.btop = {
    enable = true;

    settings = {
      vim_keys = true;
      color_theme = "nord";
      theme_background = false;
    };
  };
}
