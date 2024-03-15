# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.zsh = {
    enable = true;
    autocd = true;

    shellAliases =
      { }
      // lib.optionalAttrs config.programs.bat.enable { cat = "bat --plain"; }
      // lib.optionalAttrs config.programs.lsd.enable {
        ls = "lsd";
        tree = "lsd --tree";
      }
      // {
        # must use neovim
        emacs = "nvim";
        nano = "nvim";
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";
        # other aliases
        tf = "terraform";
      };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.dataHome}/zplug";
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = [
            "as:theme"
            "depth:1"
          ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [
            "as:plugin"
            "depth:1"
          ];
        }
        {
          name = "zsh-users/zsh-completions";
          tags = [
            "as:plugin"
            "depth:1"
          ];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [
            "as:plugin"
            "depth:1"
          ];
        }
      ];
    };

    # seems broken
    # defaultKeymap = "vicmd";

    initExtra = ''
      bindkey -v
      source ${./p10k.zsh}
    '';

    initExtraFirst = ''
      local P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      eval $(${
        if pkgs.stdenv.hostPlatform.isx86_64 then
          "/usr/local/bin"
        else if pkgs.stdenv.hostPlatform.isAarch64 then
          "/opt/homebrew/bin"
        else
          abort "Unsupported platform"
      }/brew shellenv)
    '';
  };
}
