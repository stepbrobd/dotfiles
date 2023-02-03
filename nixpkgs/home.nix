{ config, pkgs, lib, ... }:

let
  inherit (pkgs) stdenv;
in
{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.username = "StepBroBD";
  home.homeDirectory = if stdenv.isDarwin then "/Users/StepBroBD" else "/home/StepBroBD";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    bat
    btop
    code-minimap
    coreutils
    curl
    docker
    exa
    flyctl
    git
    gnupg
    jq
    mcfly
    neofetch
    neovim
    nix
    nixpkgs-fmt
    smimesign
    terraform
    tmux
    wget

    cargo
    go
    llvm
    nodejs
    nodePackages.pnpm
    spin
    texlive.combined.scheme-full

    iterm2
    vscode
    zathura
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli
  ];
}
