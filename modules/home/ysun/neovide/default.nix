{ inputs, ... }:

{ config, pkgs, ... }:

{
  programs.neovide = {
    enable = true;

    package = inputs.self.packages.${pkgs.stdenv.system}.neovide;

    settings = {
      inherit (config.programs.alacritty.settings) font;

      theme = "auto";
      frame = "none";
      title-hidden = true;
      fork = true;
      tabs = false;
    };
  };
}
