{ buildDunePackage
, cmdliner
, domain-name
, duration
, fmt
, happy-eyeballs
, ipaddr
, logs
, miou
, mtime
}:

buildDunePackage {
  pname = "happy-eyeballs-miou-unix";

  inherit (happy-eyeballs) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    cmdliner
    domain-name
    duration
    fmt
    happy-eyeballs
    ipaddr
    logs
    miou
    mtime
  ];
}
