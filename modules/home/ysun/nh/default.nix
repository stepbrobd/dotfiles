{ config, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "${config.home.homeDirectory}/Workspace/dotfiles";
  };
}
