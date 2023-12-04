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
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      # nix-darwin debug
      # ] ++ lib.optionals pkgs.stdenv.isLinux [
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
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
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      };
    };
  };
}
