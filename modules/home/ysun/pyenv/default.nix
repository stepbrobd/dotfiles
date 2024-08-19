{ config, ... }:

{
  programs.pyenv = {
    enable = true;
    rootDirectory = "${config.xdg.dataHome}/pyenv";
  };
}
