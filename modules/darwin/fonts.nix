{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    emacs-all-the-icons-fonts
    font-awesome
    nerd-fonts.intone-mono
    nerd-fonts.jetbrains-mono
    pixelmplus
    san-francisco
  ];
}
