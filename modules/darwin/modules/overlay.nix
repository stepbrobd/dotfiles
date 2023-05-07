{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.nixpkgs.overlays = [
    (self: super: {
      vscode = inputs.vscode-overlay.packages.${super.system}.vscodeInsiders;
      raycast = inputs.raycast-overlay.packages.${super.system}.raycast;
    })
  ];
}
