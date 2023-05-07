{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      packages = [
        pkgs.cacert
        pkgs.nix
        pkgs.nixpkgs-fmt
        pkgs.cachix
        pkgs.direnv
        pkgs.coreutils
        pkgs.llvm
        pkgs.rustup
        pkgs.go
        pkgs.typst
        pkgs.nodejs
        pkgs.nodePackages.pnpm
        pkgs.nodePackages.vercel
        pkgs.nodePackages."@githubnext/github-copilot-cli"
        pkgs.tmux
        pkgs.bat
        pkgs.exa
        pkgs.btop
        pkgs.curl
        pkgs.wget
        pkgs.ripgrep
        pkgs.git
        pkgs.gh
        pkgs.jq
        pkgs.mcfly
        pkgs.gnupg
        pkgs.neovim
        pkgs.lazygit
        pkgs.fzf
        pkgs.fd
        pkgs.tree-sitter
        pkgs.entr
        pkgs.code-minimap
      ];
    };
  };
}
