{ inputs, lib, ... }:

{ pkgs, ... }:

{
  imports = [ inputs.flatpak.homeManagerModules.nix-flatpak ];

  home = {
    packages = [ pkgs.flatpak ];
    sessionVariables.XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/share:/usr/local/share:$XDG_DATA_DIRS";
    sessionPath = [
      "$HOME/.local/share/flatpak/exports/bin"
      "/var/lib/flatpak/exports/bin"
    ];
  };

  services.flatpak = {
    enable = true;
    packages = [{
      inherit (pkgs.orion) appId sha256;
      bundle = lib.toString pkgs.orion;
    }];
  };
}
