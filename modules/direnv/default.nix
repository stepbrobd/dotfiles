# nixpkgs module, import directly to system settings

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
}
