{ pkgs, pkgsPrev ? pkgs }:

pkgsPrev.hydra.overrideAttrs {
  patches = [ ./oidc.patch ];
  doCheck = false;
}
