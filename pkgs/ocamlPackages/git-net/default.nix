{ buildDunePackage
, awa-mirage
, ca-certs-nss
, git-kv
, h1
, happy-eyeballs-lwt
, mimic
, mimic-happy-eyeballs
, paf
, tcpip
, tls
, tls-mirage
, uri
}:

buildDunePackage {
  pname = "git-net";

  inherit (git-kv) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    awa-mirage
    ca-certs-nss
    git-kv
    h1
    happy-eyeballs-lwt
    mimic
    mimic-happy-eyeballs
    paf
    tcpip
    tls
    tls-mirage
    uri
  ];
}
