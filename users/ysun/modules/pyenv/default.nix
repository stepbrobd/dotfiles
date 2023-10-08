{ config
, lib
, pkgs
, ...
}:

{
  programs.pyenv = {
    enable = true;
  };
}
