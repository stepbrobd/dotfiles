# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./neovim
    ./tmux
    ./zsh
  ];
}
