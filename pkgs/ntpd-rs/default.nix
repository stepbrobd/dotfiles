# drop after https://nixpkgs-tracker.ocfox.me/?pr=501712
# hits unstable

{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isDarwin
then
  pkgsPrev.ntpd-rs.overrideAttrs
  {
    __darwinAllowLocalNetworking = true;
  }
else pkgsPrev.ntpd-rs
