# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nord-nvim
    ];

    extraConfig = ''
      colorscheme nord

      set number
      set relativenumber
    '';
  };
}
