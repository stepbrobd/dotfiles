{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.intone-mono
    nerd-fonts.jetbrains-mono
    pixelmplus
    san-francisco
  ];
}
