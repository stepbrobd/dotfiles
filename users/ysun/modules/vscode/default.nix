# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.vscode = {
    enable = true;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
    ];

    userSettings = {
    };
  };
}
