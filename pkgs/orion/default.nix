{ fetchurl }:

fetchurl rec {
  name = "oriongtk.alpha.external";
  url = "https://cdn.kagi.com/flatpaks/oriongtk.alpha.external.flatpak";
  hash = "sha256-d2yv6dPGOCqh/IE0U7k1x8NTZViFbHXnRD1I138oPeY=";
  passthru = {
    appId = name;
    sha256 = hash;
  };
}
