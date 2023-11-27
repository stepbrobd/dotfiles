# nixvim home-manager options (from [nixvim](https://nix-community.github.io/nixvim))

{ config
, lib
, pkgs
, ...
}:

{
  programs.nixvim = {
    enable = true;
  };
}
