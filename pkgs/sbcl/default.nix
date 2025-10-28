{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isDarwin
# nixpkgs#456347 nixpkgs#455569 nixpkgs#456541
then pkgsPrev.sbcl.overrideAttrs { doCheck = false; }
else pkgsPrev.sbcl
