{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.nixpkgs.overlays = [
    (self: super: {
      agenix = inputs.agenix.packages.${super.system}.agenix;
      comma = inputs.comma-overlay.packages.${super.system}.comma;
      osu-lazer-bin = inputs.osu-overlay.packages.${super.system}.osu-lazer-bin;
      raycast = inputs.raycast-overlay.packages.${super.system}.raycast;
      vscode = inputs.vscode-overlay.packages.${super.system}.vscodeInsiders;
    })
  ];
}
