{ stdenv, pkgsPrev }:

if stdenv.hostPlatform.isDarwin then pkgsPrev.ghostty-bin else pkgsPrev.ghostty
