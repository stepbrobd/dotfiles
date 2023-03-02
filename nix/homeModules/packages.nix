{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      packages = with pkgs; [
        cacert
        bat
        exa
        btop
        fzf
        cocoapods
        code-minimap
        coreutils
        curl
        qemu
        colima
        docker
        lima
        flyctl
        git
        gnupg
        smimesign
        jq
        m-cli
        mcfly
        neofetch
        fd
        ripgrep
        tree-sitter
        lazygit
        neovim-nightly
        ffmpeg
        yt-dlp
        entr
        nix
        nix-output-monitor
        nix-tree
        nix-update
        nixpkgs-review
        nixpkgs-fmt
        terraform
        tmux
        wget
        rustup
        go
        llvm
        nodejs
        nodePackages.pnpm
        texlive.combined.scheme-full
        iterm2
        zathura
        vscode
        zoom-us
      ];
    };
  };
}
