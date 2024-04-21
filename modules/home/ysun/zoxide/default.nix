# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "cd" ];
  };
}
