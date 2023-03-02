{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    nixpkgs = {
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    };
  };
}
