{ inputs
, writeShellApplication
  # emacs
, emacs
, emacs-all-the-icons-fonts
  # dependencies
, binutils
, editorconfig-core-c
, fd
, fontconfig
, gnutls
, imagemagick
, ripgrep
, sqlite
, zstd
, ...
}:

writeShellApplication {
  name = "doom";

  runtimeInputs = [
    emacs
    emacs-all-the-icons-fonts
    binutils
    editorconfig-core-c
    fd
    fontconfig
    gnutls
    imagemagick
    (ripgrep.override { withPCRE2 = true; })
    sqlite
    zstd
  ];

  text = ''
    export EMACSDIR=${inputs.doom.outPath}
    exec emacs "$@"
  '';
}
