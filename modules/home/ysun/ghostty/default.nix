{ lib, ... }:

{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      window-padding-x = 4;
      window-padding-y = 4;
    } // (
      if pkgs.stdenv.isLinux then
        { window-decoration = lib.mkDefault "none"; }
      else if pkgs.stdenv.isDarwin then
        { macos-titlebar-style = lib.mkDefault "hidden"; }
      else
        abort "Unsupported OS"
    );
  };
}
