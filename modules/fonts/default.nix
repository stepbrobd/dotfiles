# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
    ];
  } // lib.optionals pkgs.stdenv.isLinux {
    enableDefaultPackages = false;
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
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "JetBrains Mono Nerd Font" "Noto Color Emoji" ];
      };
    };
  };
}
