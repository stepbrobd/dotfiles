# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./tmux
    ./zsh
  ];
}
