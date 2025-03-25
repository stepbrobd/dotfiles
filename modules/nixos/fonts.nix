{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    packages = with pkgs; [
      font-awesome
      nerd-fonts.intone-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      pixelmplus
    ];

    fontconfig = {
      enable = true;

      allowBitmaps = true;
      antialias = true;

      hinting = {
        enable = true;
        style = "full";
      };

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [
          "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "IntoneMono Nerd Font"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
