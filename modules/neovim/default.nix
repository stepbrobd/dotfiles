# nixpkgs module, import directly to system settings

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
  };
}
