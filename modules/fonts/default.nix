# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

let
  # remove after nix-darwin #752 closes
  fontPkgs =
    if pkgs.stdenv.isLinux
    then "packages"
    else if pkgs.stdenv.isDarwin
    then "fonts"
    else abort "Unsupported OS";
in
{
  fonts = {
    fontDir.enable = true;
    ${fontPkgs} = with pkgs; [
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      font-awesome
    ];
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
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
