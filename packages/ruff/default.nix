{ lib
, stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

# remove after nixpkgs 374697 merges into nixos-unstable
# https://nixpkgs-tracker.ocfox.me/?pr=374697
pkgsPrev.ruff.overrideAttrs
  (oldAttrs: {
    doCheck = !stdenv.hostPlatform.isStatic;
    postInstallCheck = null;
    checkFlags = [ ];
    cargoTestFlags = lib.optionals stdenv.hostPlatform.isDarwin [
      "--workspace"
      "--exclude=red_knot"
    ];
  })
