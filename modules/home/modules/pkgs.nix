{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config.home.packages = with pkgs.nodePackages_latest;  with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    cacert
    nix
    nixpkgs-fmt
    cachix
    direnv
    coreutils
    llvm
    rustup
    go
    typst
    texlive.combined.scheme-full
    nodejs
    pnpm
    vercel
    github-copilot-cli
    tmux
    bat
    exa
    btop
    curl
    wget
    ripgrep
    git
    gh
    jq
    mcfly
    gnupg
    neovim
    lazygit
    fzf
    fd
    tree-sitter
    entr
    code-minimap
    qemu
    docker
    terraform
    awscli2
    flyctl
    ffmpeg
    yt-dlp
    zathura
    vscode
    zoom-us
  ] ++ (lib.optionals pkgs.stdenv.isDarwin [
    smimesign
    cocoapods
    lima
    colima
    iterm2
    raycast
    iina
    osu-lazer-bin
  ]) ++ (lib.optionals pkgs.stdenv.isLinux [
    mpv
  ]);
}
