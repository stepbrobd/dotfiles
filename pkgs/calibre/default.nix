# drop when https://github.com/nixos/nixpkgs/pull/493988 hits master
# also in ../../.github/workflows/bump.yaml

{ pkgsPrev, qt6 }:

pkgsPrev.calibre.overrideAttrs {
  preInstall = ''
    export QMAKE="${qt6.qtbase}/bin/qmake"
  '';
}
