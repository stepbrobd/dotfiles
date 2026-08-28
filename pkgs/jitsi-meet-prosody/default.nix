{ fetchurl
, pkgsPrev
}:

pkgsPrev.jitsi-meet-prosody.overrideAttrs (final: prev: {
  version = "1.0.9365";

  src = fetchurl {
    url = "https://download.jitsi.org/stable/jitsi-meet-prosody_${final.version}-1_all.deb";
    hash = "sha256-tgRYD4Ip+QAbOKCFTXVbou5Qv+Us+pNtzi5xlT/bFIc=";
  };

  passthru = prev.passthru // {
    autobump = true;
    updateScript = [ ../jitsi-meet/update.sh "jitsi-meet-prosody" ];
  };
})
