{ fetchurl
, jdk17_headless
, pkgsPrev
}:

# jibri 8 targets java 17
(pkgsPrev.jibri.override { jdk11_headless = jdk17_headless; }).overrideAttrs (final: prev: {
  version = "8.0-205-g206e038";

  src = fetchurl {
    url = "https://download.jitsi.org/stable/jibri_${final.version}-1_all.deb";
    hash = "sha256-DJyBNjCgesg0P1SSU8mi3vVN9TK5sU/eLS1PLzEsIRE=";
  };

  passthru = prev.passthru // {
    autobump = true;
    updateScript = [ ../jitsi-meet/update.sh "jibri" ];
  };
})
