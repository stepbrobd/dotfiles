# drop after https://nixpkgs-tracker.ocfox.me/?pr=501712
# hits unstable

{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isDarwin
then
  pkgsPrev.alacritty.overrideAttrs
  {
    __darwinAllowLocalNetworking = true;
  }
else pkgsPrev.alacritty
