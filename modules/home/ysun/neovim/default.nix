# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.nixvim;
  };
}
