# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat --plain";
      ls = "lsd";
      tree = "lsd --tree";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    zplug = {
      enable = true;
      zplugHome = "${config.home.homeDirectory}/.config/zplug";
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [ "as:plugin" "depth:1" ];
        }
        {
          name = "zsh-users/zsh-completions";
          tags = [ "as:plugin" "depth:1" ];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [ "as:plugin" "depth:1" ];
        }
      ];
    };
  };
}
