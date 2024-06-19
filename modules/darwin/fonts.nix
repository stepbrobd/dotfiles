# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    nerdfonts
    jetbrains-mono
    font-awesome
  ];
}
