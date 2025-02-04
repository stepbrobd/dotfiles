{ inputs, lib, ... }:

{ config, pkgs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [ starship ];

  programs.carapace.enable = true;

  programs.nushell = {
    enable = true;

    shellAliases = lib.mkMerge [
      # bat
      (lib.mkIf config.programs.bat.enable { cat = "bat --plain"; })
      # lsd
      (lib.mkIf config.programs.lsd.enable {
        # ls = "lsd"; # use nushell builtin ls
        tree = "lsd --tree";
      })
      # must use neovim
      rec {
        emacs = "nvim";
        nano = "nvim";
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";
        # NOTE: also in zsh user module
        # emacs daemon like behavior but for neovim
        vims = nvims;
        nvims = ''pwd | sha256sum | cut -c1-8 | xargs -I{} nvim --headless --listen "/tmp/nvim.{}"'';
        # attach to a nvim "daemon"
        vimc = nvimc;
        nvimc = ''pwd | sha256sum | cut -c1-8 | xargs -I{} nvim --remote-ui --server "/tmp/nvim.{}"'';
      }
      # tailscale
      (lib.mkIf pkgs.stdenv.isDarwin {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      })
      # other aliases
      { tf = "terraform"; }
    ];

    configFile.text = /* nu */ ''
      $env.config = {
        edit_mode: vi
        show_banner: false
      }
      $env.PROMPT_COMMAND = ""
      $env.PROMPT_COMMAND_RIGHT = ""
      $env.PROMPT_INDICATOR = ""
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
      $env.PROMPT_MULTILINE_INDICATOR = ""
    '';
  };
}
