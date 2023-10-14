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
      zplugHome = "${config.xdg.dataHome}/zplug";
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

    initExtra = ''
      source ${./p10k.zsh}
    '';

    initExtraFirst = ''
      export GPG_TTY=$(tty)
      local P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
  };
}
