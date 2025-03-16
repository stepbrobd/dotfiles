{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isLinux
then
  pkgsPrev.cfspeedtest.overrideAttrs
    (oldAttrs: {
      patches = [ ./addr.patch ];
    })
else
  pkgsPrev.cfspeedtest.overrideAttrs
    (_: {
      patches = [ ./addr.patch ];
      meta.broken = false;
    })
