# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
