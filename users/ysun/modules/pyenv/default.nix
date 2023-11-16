# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.pyenv = {
    enable = true;
    rootDirectory = "${config.xdg.dataHome}/pyenv";
  };
}
