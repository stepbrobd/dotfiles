{ lib, ... }:

{ config, pkgs, ... }:

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
        {
          macos-titlebar-style = lib.mkDefault "hidden";
          font-size = lib.mkForce (lib.ceil (config.stylix.fonts.sizes.terminal * 4.0 / 3.0));
        }
      else
        abort "Unsupported OS"
    );
  };
}
