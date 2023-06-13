{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.nixpkgs.overlays = [
    (self: super: {
      comma = inputs.comma-overlay.packages.${super.system}.comma;
      devenv = inputs.devenv-overlay.packages.${super.system}.devenv;
      osu-lazer-bin = inputs.osu-overlay.packages.${super.system}.osu-lazer-bin;
      raycast = inputs.raycast-overlay.packages.${super.system}.raycast;
      vscode = inputs.vscode-overlay.packages.${super.system}.vscodeInsiders;
    })
  ];
}
