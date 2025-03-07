{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isDarwin
then
  pkgsPrev.tailscale.overrideAttrs
    (_: { doCheck = false; }) # remove after nixpkgs #387340 closes
else pkgsPrev.tailscale
