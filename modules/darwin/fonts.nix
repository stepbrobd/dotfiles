{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    font-awesome
  ];
}
