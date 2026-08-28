{ fetchurl
, pkgsPrev
}:

pkgsPrev.jicofo.overrideAttrs (final: prev: {
  version = "1.0-1189";

  src = fetchurl {
    url = "https://download.jitsi.org/stable/jicofo_${final.version}-1_all.deb";
    hash = "sha256-c6YQT/okrB/PZmD7jHPte+qWpevfKqnXm4oAtTVjm7s=";
  };

  passthru = prev.passthru // {
    autobump = true;
    updateScript = [ ../jitsi-meet/update.sh "jicofo" ];
  };
})
