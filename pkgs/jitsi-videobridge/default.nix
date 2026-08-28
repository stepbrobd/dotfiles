{ fetchurl
, pkgsPrev
}:

pkgsPrev.jitsi-videobridge.overrideAttrs (final: prev: {
  version = "2.3-307-g4bb0aead1";

  src = fetchurl {
    url = "https://download.jitsi.org/stable/jitsi-videobridge2_${final.version}-1_all.deb";
    hash = "sha256-5im9MH8xwJMH3PklZX/Tli641HmmxV6df5jWfsBYxDo=";
  };

  passthru = prev.passthru // {
    autobump = true;
    updateScript = [ ../jitsi-meet/update.sh "jitsi-videobridge" ];
  };
})
