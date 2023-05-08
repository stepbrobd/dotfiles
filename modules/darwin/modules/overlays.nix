{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.nixpkgs.overlays = [
    (self: super: {
      neovim = inputs.neovim-overlay.packages.${super.system}.neovim;
      nix-direnv = super.nix-direnv.override { enableFlakes = true; };
      vscode = inputs.vscode-overlay.packages.${super.system}.vscodeInsiders;
      raycast = inputs.raycast-overlay.packages.${super.system}.raycast;
    })
  ];
}
