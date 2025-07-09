{ emacsWithDoom, pkgs }:

emacsWithDoom {
  doomDir = ./.;
  doomLocalDir = "~/.local/share/doom";
  experimentalFetchTree = true;

  extraPackages = epkgs: with epkgs; [
    aggressive-indent
    markdown-mode
    nix-mode
    treesit-grammars.with-all-grammars
  ];

  extraBinPackages = with pkgs; [
    emacs-all-the-icons-fonts
    fd
    git
    gnutls
    imagemagick
    (ripgrep.override { withPCRE2 = true; })
    sqlite
    zstd
  ];
}
