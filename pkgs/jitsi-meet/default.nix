{ pkgsPrev }:

pkgsPrev.jitsi-meet.overrideAttrs (old: {
  patches = old.patches or [ ] ++ [ ./plausible.patch ];
  meta = old.meta // { knownVulnerabilities = [ ]; };
})
