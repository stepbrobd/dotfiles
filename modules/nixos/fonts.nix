{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      # nerdfonts
      jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
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
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
