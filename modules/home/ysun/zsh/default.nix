{ inputs, lib, ... }:

{ config, pkgs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [ starship ];

  programs.carapace.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = lib.mkMerge [
      # bat
      (lib.mkIf config.programs.bat.enable { cat = "bat --plain"; })
      # lsd
      (lib.mkIf config.programs.lsd.enable {
        ls = "lsd";
        tree = "lsd --tree";
      })
      # must use neovim
      rec {
        emacs = "nvim";
        nano = "nvim";
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";
        # emacs daemon like behavior but for neovim
        vims = nvims;
        nvims = "nvim --headless --listen '/tmp/nvim.'$(pwd | sha256sum | cut -c1-8)";
        # attach to a nvim "daemon"
        vimc = nvimc;
        nvimc = "nvim --remote-ui --server '/tmp/nvim.'$(pwd | sha256sum | cut -c1-8)";
      }
      # tailscale
      (lib.mkIf pkgs.stdenv.isDarwin {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      })
      # other aliases
      { tf = "terraform"; }
    ];

    # seems broken
    # defaultKeymap = "vicmd";
    initExtra = "bindkey -v";

    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      eval $(${
        if pkgs.stdenv.hostPlatform.isx86_64 then
          "/usr/local/bin"
        else if pkgs.stdenv.hostPlatform.isAarch64 then
          "/opt/homebrew/bin"
        else
          abort "Unsupported OS"
      }/brew shellenv)
    '';
  };
}
