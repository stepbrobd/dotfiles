# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  fonts = {
    fontDir.enable = true;
    # change to packages after nix-darwin #752 closes
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nerdfonts
      jetbrains-mono
      font-awesome
    ];
  };
}
