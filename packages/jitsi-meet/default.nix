{ pkgs
, pkgsPrev ? pkgs
, # `pkgsPrev` only provided in overlays
}:

pkgsPrev.jitsi-meet.overrideAttrs (prev: {
  patches = [ ./plausible.patch ];
})
