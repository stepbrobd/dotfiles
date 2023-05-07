{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    programs = {
      home-manager = {
        enable = true;
      };
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
