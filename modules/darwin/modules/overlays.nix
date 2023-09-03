{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.nixpkgs.overlays = [
    (self: super: {
      agenix = inputs.agenix.packages.${super.system}.agenix;
      osu-lazer-bin = inputs.osu-lazer-bin.packages.${super.system}.osu-lazer-bin;
      raycast = inputs.raycast.packages.${super.system}.raycast;
      vscode = inputs.vscode.packages.${super.system}.vscodeInsiders;
    })
  ];
}
