{ stdenv, pkgsPrev }:

if stdenv.isDarwin then pkgsPrev.ghostty-bin else pkgsPrev.ghostty
